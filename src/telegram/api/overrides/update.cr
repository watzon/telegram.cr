class Telegram::API
  class Update
    @[JSON::Field(ignore: true)]
    getter update_action : UpdateAction { UpdateAction.from_update(self) }

    {% for action in Telegram::UpdateAction.constants %}
    def {{ action.id.underscore }}_entity?
      self.update_action.{{ action.id.underscore }}?
    end
    {% end %}
  end
end
