# Telegram.cr

Telegram.cr is a completely new library meant to replace [Touramline](https://github.com/protoncr/tourmaline). It's designed with [Lucky Framework](https://luckyframework.org) intergration in mind. Types and methods are auto-generated using [PaulSonOfLars/telegram-bot-api-spec](https://github.com/PaulSonOfLars/telegram-bot-api-spec), which makes the library super easy to update when new features are released.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     telegram:
       github: watzon/telegram.cr
   ```

2. Run `shards install`

## Contributing

1. Fork it (<https://github.com/watzon/telegram.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
