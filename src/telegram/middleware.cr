require "./context"

module Telegram
  alias MiddlewareFn = Proc(Context, Nil)

  class Middleware
    @proc : MiddlewareFn

    property next_middleware : Middleware?

    def initialize(@proc : MiddlewareFn)
    end

    def self.new(&proc : MiddlewareFn)
      self.new(proc)
    end

    def call(ctx : Context)
      @proc.call(ctx)
      self.next(ctx)
    end

    def next(ctx : Context)
      self.next_middleware.try(&.call(ctx))
    rescue ex : StopMiddlewareExecution
    end
  end
end
