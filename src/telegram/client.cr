require "./api"
require "./composer"

module Telegram
  class Client < Composer

    @me : API::User?

    getter api : API
    getter? polling : Bool = false
    getter? last_update_id : Int32 = 0

    class_getter! instance : Client

    def initialize(token : String)
      super()
      raise "empty token!" if (token.empty?)
      Habitat.raise_if_missing_settings!
      @api = API.new(token)
      @@instance = self
    end

    def bot_info
      if me = @me
        return me
      end

      raise Error.new("bot information unavailable; make sure to call `client.init` before accessing `client.bot_info`.")
    end

    def init
      if me = @me
        Log.debug { "bot is already initialized" }
      else
        @me = self.api.get_me
        Log.debug { "bot initialized; running as #{bot_info.username}" }
      end
    end

    def handle_update(update : API::Update)
      Log.debug { "processing update #{update.update_id}" }
      api = API.new(self.api.token)
      # TODO: Implement transformers and copy
      ctx = Context.new(update, api, self.bot_info)
      run(self.middleware, ctx)
    rescue ex
      Log.error(exception: ex) { "error in middleware for update #{update.update_id}" }
      raise ex
    end

    # Start your bot using the long polling method. See `Telegram::API#get_updates`
    # for available `options`.
    def start(drop_pending_updates = false, **options, &block)
      if polling?
        Log.debug { "bot is already polling" }
        return
      end

      with_retries do
        self.init
      end

      with_retries do
        api.delete_webhook(drop_pending_updates)
      end

      Log.debug { "starting polling" }
      yield self.bot_info
      @polling = true

      while @polling
        begin
          options = options.merge({ offset: @last_update_id + 1, timeout: 30 })
          if updates = self.api.get_updates(**options)
            updates.each do |update|
              handle_update(update)
              @last_update_id = update.update_id
            end
          end
        rescue ex
          Log.error(exception: ex) { "call to getUpdates failed, retrying in 3 seconds" }
          sleep 3.seconds
        end
      end
    end

    def start(drop_pending_updates = false, **options)
      start(drop_pending_updates, **options) { }
    end

    def stop
      if self.polling?
        Log.debug { "stopping bot; saving update offset" }
        @polling = false
        offset = @last_update_id + 1
        self.api.get_updates(offset: offset, limit: 1)
      else
        Log.debug { "bot is not running" }
      end
    end

    def with_retries(&block)
      success = false
      until success
        begin
          block.call
          success = true
        rescue ex
          Log.error(exception: ex) { "runtime error" }
          case ex
          when Socket::Error
          when Telegram::Error
            code = ex.code
            next if code && code >= 500
            if ex.is_a?(Error::RetryAfter)
              next(sleep ex.seconds)
            end
            raise ex
          end
        end
      end
    end

    # def command(*args, **kwargs, &block : CommandMiddleware::Context ->)
    #   middlware = Telegram::CommandMiddleware.new(*args, **kwargs, &block)
    #   self.use(middlware)
    # end
  end
end
