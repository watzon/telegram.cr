require "./helpers"
require "./context"
require "./middleware"

module Telegram
  class BotError < Exception
    getter context : Context

    def initialize(error, context)
      super("BotError", error)
      @context = context
    end
  end

  alias MiddlewareFactory = Proc(Context, Middleware | MiddlewareFn | Composer | Array(Middleware | MiddlewareFn | Composer))
  alias AcceptableMiddleware = Middleware | MiddlewareFn | Composer
  alias RouterFn = Proc(Context, String) | Proc(Context, Nil) | Proc(Context, String | Nil)
  alias ErrorHandler = Proc(BotError, Nil)

  class Composer
    @handler : Middleware

    # Create a new `Composer` with the given middleware
    def initialize(middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      @handler = middleware.size == 0 ?
        Composer.pass :
        middleware
          .map(&->Composer.flatten(AcceptableMiddleware))
          .reduce(&->Composer.concat(Middleware, Middleware))
    end

    # :ditto:
    def self.new(*middleware : AcceptableMiddleware)
      Composer.new(middleware.to_a)
    end

    # :ditto:
    def self.new(&block : MiddlewareFn)
      Composer.new(block)
    end

    # Returns the middleware that make up this Composer.
    def middleware
      @handler
    end

    # Run the given `middleware` with the given `context`.
    def run(middleware : Middleware, context : Context)
      middleware.call(context)
    end

    # Register the given `middleware` with the current Composer. Registered middleware
    # reveive all updates and are contactenated into a single `Middleware`.
    #
    # This can be used to easily register new plugins:
    # ```crystal
    # bot.use(SomeTelegramPlugin.new)
    # ```
    #
    # This returns a new instance of `Composer` which can be further extended.
    def use(middleware : Array(AcceptableMiddleware))
      composer = Composer.new(middleware.to_a)
      @handler = Composer.concat(self.middleware, Composer.flatten(composer))
      composer
    end

    # :ditto:
    def use(*middleware : AcceptableMiddleware)
      self.use(middleware.to_a)
    end

    # :ditto:
    def use(&proc : MiddlewareFn)
      self.use(proc)
    end

    # Registers `middleware` that will only be executed when certain `UpdateAction`s are
    # included in an update. The `filter` specifies which actions you want to act on.
    #
    # For example:
    # ```crystal
    # # All message updates
    # bot.on(:message) { |ctx| ... }
    #
    # # Only messages containing text or a caption
    # bot.on([:text, :caption]) { |ctx| ... }
    #
    # # Only text messages with a URL
    # bot.on(:text).on(:url) { |ctx| ... }
    #
    # # Messages containing a photo
    # bot.on(:photo) { |ctx| ... }
    # ```
    #
    # As can be seen in the above example, passing multiple filters in an array works
    # as an `OR`, while chaining multiple `on` calls together works as an `AND`.
    def on(filter, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      self.filter(middleware) { |ctx| Filter.match_filter(filter).call(ctx) }
    end

    # :ditto:
    def on(filter, *middleware : AcceptableMiddleware)
      self.on(filter, middleware.to_a)
    end

    # :ditto:
    def on(filter, &block : MiddlewareFn)
      self.on(filter, block)
    end

    # Registers a `middleware` that is executed when the message contains a specific pattern.
    # You can use either a regular expression, a string, or an array containing either:
    #
    # ```crystal
    # # Match some exact text
    # bot.hears("Crystal is great") { |ctx| ... }
    #
    # # Match a regular expression
    # bot.hears(/crystal/i) { |ctx| ... }
    # ```
    #
    # Passing multiple filters in an array works as an `OR`, while chaining multiple `on`
    # calls together works as an `AND`.
    def hears(trigger, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      trg = Composer.trigger_fn(trigger)
      self.on([:text, :caption]).filter(middleware) do |ctx|
        update = ctx.update
        msg = (update.message || update.channel_post).not_nil!
        txt = (msg.text || msg.caption).not_nil!
        Composer.match(ctx, txt, trg)
      end
    end

    # :ditto:
    def hears(trigger, *middleware : AcceptableMiddleware)
      self.hears(trigger, middleware.to_a)
    end

    # :ditto:
    def hears(trigger, &block : MiddlewareFn)
      self.hears(trigger, block)
    end

    # Registers a middleware that will be called when a certain command is found:
    #
    # ```crystal
    # # reacts to `/start` commands
    # bot.command("start") { |ctx| ... }
    #
    # # reacts to `/help` commands
    # bot.command("help") { |ctx| ... }
    # ```
    #
    # The rest of the text is provided as `ctx.match`.
    #
    # !!! note
    #     Commands are only matched at the beginning of a message. To match a command
    #     inside of a message you could use `bot.on(:bot_command)` in conjunction with
    #     the `hears` handler.
    #
    # !!! note
    #     By default commands are detected in channel posts too, which means
    #     `ctx.message` may be undefined. You should always use `ctx.msg` instead to
    #     grab both group and channel messages.
    def command(command, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      at_commands = Set(String).new
      no_at_commands = Set(String).new

      Helpers.to_array(command).each do |cmd|
        if cmd.starts_with?('/')
          raise "Do not include `/` when registering new command handlers (use `#{cmd[1..]}` not `#{cmd}`)"
        end
        set = cmd.index('@') ? at_commands : no_at_commands
        set.add(cmd)
      end

      self.on(:bot_command).filter(middleware) do |ctx|
        update = ctx.update
        msg = (update.message || update.channel_post).not_nil!
        txt = (msg.text || msg.caption).not_nil!

        msg.entities.any? do |ent|
          break false if ent.type != "bot_command"
          break false if ent.offset != 0
          cmd = txt[1, ent.length]
          if no_at_commands.includes?(cmd) || at_commands.includes?(cmd)
            ctx.set("match", Helpers.try_strip(txt[(cmd.size + 1)..]?))
            break true
          end
          index = cmd.index('@')
          break false unless index
          at_target = cmd[(index + 1)..]
          break false unless at_target.downcase == ctx.me.username.to_s.downcase
          at_command = cmd[0...index]
          if no_at_commands.includes?(at_command)
            ctx.set("match", Helpers.try_strip(txt[(cmd.size + 1)..]?))
            break true
          end
          break false
        end
      end
    end

    # :ditto:
    def command(command, *middleware : AcceptableMiddleware)
      self.command(command, middleware.to_a)
    end

    # :ditto:
    def command(command, &block : MiddlewareFn)
      self.command(command, block)
    end

    # Registers some middleware for callback queries (updates that Telegram sends when a user
    # clicks on a button in an inline keyboard).
    #
    # This is essentially the same as calling:
    # ```crystal
    # bot.on(:callback_query) { |ctx| ... }
    # ```
    #
    # but it also allows you to match the query data against a given string or regular expression.
    #
    # ```crystal
    # # Create an inline keyboard
    # kb = Telegram::InlineKeyboardMarkup.new.text("Go!", "button-payload")
    #
    # # Send a message with the keyboard
    # bot.api.send_message(chat_id, "Press a button!", reply_markup: kb)
    #
    # # Listen for a button press with that specific payload
    # bot.callback_query("button-payload") { |ctx| ... }
    # ```
    #
    # !!! note
    #     Always remember to call `answer_callback_query`, even if you don't do anything
    #     with it.
    #     ```crystal
    #     bot.callback_query("button-payload") do |ctx|
    #       ctx.answer_callback_query
    #     end
    #     ```
    #
    # If you pass an array of triggers, your middleware will be called when
    # at least one of them matches.
    def callback_query(trigger, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      trg = Composer.trigger_fn(trigger)
      self.on(:callback_query).filter(middlware) do |ctx|
        if data = ctx.callback_query!.data
          Composer.match(ctx, data, trg)
        else
          false
        end
      end
    end

    # :ditto:
    def callback_query(trigger, *middleware : AcceptableMiddleware)
      self.callback_query(trigger, middleware.to_a)
    end

    # :ditto:
    def callback_query(trigger, &block : MiddlewareFn)
      self.callback_query(trigger, block)
    end

    # Registers some middleware for game queries (updates that Telegram sends when a user
    # clicks an inline button to launch an HTML5 game).
    #
    # This is functionally the same as `Composer#callback_query`, but it only matches
    # when a `game_short_name` is provided.
    def game_query(trigger, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      trg = Composer.trigger_fn(trigger)
      self.on(:callback_query).filter(middleware) do |ctx|
        if data = ctx.callback_query!.game_short_name
          Composer.match(ctx, data, trg)
        else
          false
        end
      end
    end

    # :ditto:
    def game_query(trigger, *middleware : AcceptableMiddleware)
      self.game_query(trigger, middleware.to_a)
    end

    # :ditto:
    def game_query(trigger, &block : MiddlewareFn)
      self.game_query(trigger, block)
    end

    # Registers some middleware for inline queries (updates that Telegram sends when a user
    # types "@YourBotName ..." into a text field). Your bot will receive the inline query
    # and can respond with a number of different results. Check out
    # https://core.telegram.org/bots/inline to read more about inline queries.
    #
    # !!! note
    #     You have to enable inline mode in [@BotFather](https://t.me/BotFather)
    #
    # ```crystal
    # bot.inline_query("query") do |ctx|
    #   # Answer the inline query, confer https://core.telegram.org/bots/api#answerinlinequery
    #   ctx.answer_inline_query(...)
    # end
    # ```
    def inline_query(trigger, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      trg = Composer.trigger_fn(trigger)
      self.on(:inline_query).filter(middleware) do |ctx|
        if query = ctx.inline_query!.query
          Composer.match(ctx, query, trg)
        else
          false
        end
      end
    end

    # :ditto:
    def inline_query(trigger, *middleware : AcceptableMiddleware)
      self.inline_query(trigger, middleware.to_a)
    end

    # :ditto:
    def inline_query(trigger, &block : MiddlewareFn)
      self.inline_query(trigger, block)
    end

    # Registers middleware behind a custom filter function that operates on the context object and
    # determines whether or not to contuinue middleware execution. In other words, the middleware following
    # this one in a chain will only be called if the filter function returns `true`.
    #
    # ```crystal
    # my_filter = ->(ctx : Context) { ctx.text == "hello" }
    # bot.on(:text).filter(my_filter) do |ctx|
    #   # Will only be called if `ctx.text` is "hello"
    #   # ...
    # end
    # ```
    #
    # !!! note
    #     This is a more advanced function and is not needed for most use cases.
    def filter(predicate : Filter::Predicate, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      composer = Composer.new(middleware)
      self.branch(predicate, composer, Composer.pass)
      composer
    end

    # :ditto:
    def filter(predicate, *middleware : AcceptableMiddleware)
      self.filter(predicate, middleware.to_a)
    end

    # :ditto:
    def filter(middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware, &predicate : Filter::Predicate)
      self.filter(predicate, middleware)
    end

    # :ditto:
    def filter(*middleware : AcceptableMiddleware, &predicate : Filter::Predicate)
      self.filter(predicate, middleware.to_a)
    end

    # Registers middleware behind a custom filter function that operates on the context object and
    # determines whether or not to contuinue middleware execution. In other words, the middleware following
    # this one in a chain will only be called if the filter function returns `false`. This is functionally
    # the opposite of `Composer#filter`.
    #
    # ```crystal
    # my_filter = ->(ctx : Context) { ctx.text == "hello" }
    # bot.on(:text).drop(my_filter) do |ctx|
    #   # Will only be called if `ctx.text` is not "hello"
    #   # ...
    # end
    # ```
    #
    # !!! note
    #     This is a more advanced function and is not needed for most use cases.
    def drop(predicate : Filter::Predicate, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      self.filter(middleware) { |ctx| !predicate.call(ctx) }
    end

    # :ditto:
    def drop(predicate, *middleware : AcceptableMiddleware)
      self.drop(predicate, middleware.to_a)
    end

    def drop(middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware, &predicate : Filter::Predicate)
      self.drop(predicate, middleware)
    end

    # :ditto:
    def drop(*middleware : AcceptableMiddleware, &predicate : Filter::Predicate)
      self.drop(predicate, middleware.to_a)
    end

    # Registers some middleware that run concurrently with other middleware in the
    # stack.
    #
    # ```crystal
    # bot.use(...) # Will run first
    # bot.fork(...) # Will start second, but will run in the background
    # bot.use(...) # Will also run second
    # ```
    #
    # Forking is functionally the same as running your middleware in a `spawn` block, but
    # also applies to all the middleware that follow it in the chain.
    def fork(middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      composer = Composer.new(middleware)
      fork = Composer.flatten(composer)
      self.use { |ctx| spawn run(fork, ctx) }
      composer
    end

    # :ditto:
    def fork(*middleware : AcceptableMiddleware)
      self.fork(middleware.to_a)
    end

    # :ditto:
    def fork(&block : MiddlewareFn)
      self.fork(block)
    end

    # Executes some middleware that are generated on the fly for each
    # context. Pass a factory function which generates a middleware (or
    # an array of middleware) for the given context.
    #
    # ```crystal
    # bot.lazy { |ctx| create_some_middleware(ctx) }
    # ```
    #
    # You can also return an empty array (`[] of Middleware`) if you don't want to
    # run any middleware for the given context. This is the same as returning an
    # empty `Composer` object.
    #
    # !!! note
    #     This is a more advanced function and is not needed for most use cases.
    def lazy(factory : MiddlewareFactory)
      self.use do |ctx|
        middleware = factory.call(ctx)
        arr = Helpers.to_array(middleware)
        Composer.flatten(Composer.new(arr)).call(ctx)
      end
    end

    # :ditto:
    def lazy(&block : MiddlewareFactory)
      self.lazy(block)
    end

    # This allows you to branch between different middleware per context object in much
    # the same way you would branch between HTTP routes in a traditional web framework.
    # You can pass three things to it:
    # 1) a routing function.
    # 2) a hash of handlers.
    # 3) a fallback middleware.
    #
    # The routing function decides based on the context object what middleware to run.
    # Each middleware is idenfied by a key, so the routing function simply returns the
    # key of the middleware to run.
    #
    # ```crystal
    # route_handlers = {
    #   "even_updates" => ->(ctx : Context) { ... },
    #   "odd_updates" => ->(ctx : Context) { ... },
    # }
    #
    # router = ->(ctx : Telegram::Context) do
    #   if ctx.update.update_id.even?
    #     "even_updates"
    #   else
    #     "odd_updates"
    #   end
    # end
    #
    # bot.route(router, route_handlers)
    # ```
    #
    # If a fallback is provided as a third argument, it will be run if the routing
    # function returns `nil` or if the provided key doesn't match.
    def route(router : RouterFn, handlers : Hash(String, AcceptableMiddleware), fallback : AcceptableMiddleware = Composer.pass)
      self.lazy do |ctx|
        if route = router.call(ctx)
          handlers[route]? || [] of AcceptableMiddleware
        else
          fallback
        end
      end
    end

    # :ditto:
    def route(handlers : Hash(String, AcceptableMiddleware), fallback : AcceptableMiddleware = Composer.pass, &router : RouterFn)
      self.route(router, handlers, fallback)
    end

    # Allows you to branch between two cases for a given context object.
    #
    # This method takes a predicate function and two middleware. If the predicate
    # returns true, `true_mw` will be called, otherwise `false_mw` will be called.
    #
    # !!! note
    #     This is a more advanced function and is not needed for most use cases.
    def branch(predicate : Filter::Predicate, true_mw : AcceptableMiddleware, false_mw : AcceptableMiddleware)
      self.lazy do |ctx|
        predicate.call(ctx) ? true_mw : false_mw
      end
    end

    # :ditto:
    def branch(true_mw : AcceptableMiddleware, false_mw : AcceptableMiddleware, &predicate : Filter::Predicate)
      self.branch(predicate, true_mw, false_mw)
    end

    # Installs an error boundary that catches errors that happen inside the given middleware.
    # This allows you to insert custom error handlers into the pipeline for some parts
    # of your bot, while leaving others untouched.
    #
    # ```crystal
    # error_handler = ->(err : BotError) do
    #   puts "Error boundary caught error!"
    #   puts err
    # end
    #
    # # All passed middleware will be protected by the error boundary.
    # safe = bot.error_boundary(error_handler, middleware0, middleware1, middleware2)
    #
    # # This will also be protected
    # safe.on(:message, middleware3)
    #
    # # No error from middleware4 will reach the `error_handler` from above.
    #
    # Do nothing on error, and run outside middleware
    # suppress = ->(err : BotError) { }
    # safe.error_boundary(suppress).on(:edited_message, middleware4)
    # ```
    def error_boundary(error_handler : ErrorHandler, middleware : Array(AcceptableMiddleware) = [] of AcceptableMiddleware)
      composer = Composer.new(middleware)
      bound = Composer.flatten(composer)
      self.use do |ctx|
        begin
          bound.call(ctx)
        rescue ex : StopMiddlewareExecution
          raise ex
        rescue ex : Exception
          error_handler.call(BotError.new(ex, ctx))
        end
      end
    end

    # :ditto:
    def error_boundary(error_handler : ErrorHandler, *middleware : AcceptableMiddleware)
      self.error_boundary(error_handler, middleware.to_a)
    end

    # :ditto:
    def error_boundary(error_handler : ErrorHandler, &middleware : MiddlewareFn)
      self.error_boundary(error_handler, middleware)
    end

    def self.pass
      Middleware.new { }
    end

    def self.flatten(mw : AcceptableMiddleware) : Middleware
      case mw
      in Middleware
        mw
      in MiddlewareFn
        Middleware.new(mw)
      in Composer
        Middleware.new do |ctx|
          mw.middleware.call(ctx)
        end
      end
    end

    def self.concat(first : Middleware, and_then : Middleware) : Middleware
      Middleware.new do |ctx|
        first.next_middleware = and_then
        first.call(ctx)
      end
    end

    def self.trigger_fn(trigger : String | Regex | Array(String | Regex))
      arr = Helpers.to_array(trigger)
      arr.map do |t|
        if t.is_a?(String)
          t = /\b#{t}\b/
        end
        ->(txt : String) { t.match(txt) }
      end
    end

    def self.match(ctx : Context, content : String, triggers : Array(Proc(String, Regex::MatchData | Nil)))
      triggers.each do |t|
        res = t.call(content)
        if res
          ctx.set(:match, res)
          return true
        end
      end
      false
    end
  end
end
