require "dexter"
require "habitat"
require "http_proxy"
require "./api/types"

module Telegram
  DEFAULT_ENDPOINT = "https://api.telegram.org"

  Habitat.create do
    setting endpoint : String = DEFAULT_ENDPOINT
    setting pool_capacity : Int32 = 5
    setting pool_timeout : Float64 = 0.1
    setting initial_pool_size : Int32 = 1
    setting proxy : HTTP::Proxy? = nil
    setting proxy_uri : String | URI | Nil = nil
  end
end
