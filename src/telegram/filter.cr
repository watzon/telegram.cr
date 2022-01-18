require "./context"
require "./update_action"

module Telegram
  module Filter
    extend self

    alias Predicate = Proc(Context, Bool)

    def match_filter(filter) : Predicate
      parsed = parse(filter)
      ->(ctx : Context) { ctx.update.update_action.includes?(parsed) }
    end

    def parse(filter) : UpdateAction
      if filter.is_a?(Array)
        filter
          .flatten
          .compact
          .map(&->parse(String | Symbol | UpdateAction))
          .reduce { |acc, f| acc | f }
      else
        filter.is_a?(UpdateAction) ?
          filter :
          UpdateAction.parse(filter.to_s)
      end
    end
  end
end
