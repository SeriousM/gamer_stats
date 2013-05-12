require 'minitest/spec'
require 'minitest/autorun'
require 'vcr'

require 'gamer_stats'

include GamerStats
include Achievements

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'test/cassettes'
  # :new_episodes = add new requests to the same cassette
  c.default_cassette_options = { :record => :new_episodes, :erb => true }
  # dont raise exceptions when no cassette is in the tray
  c.allow_http_connections_when_no_cassette = true
  # ignore local host calls (local development)
  c.ignore_localhost = true

  # catch all requests and store them
  c.around_http_request do |request|
    VCR.use_cassette("all", &request)
  end
end

# dont raise exceptions when the http connection is unexpected (turn off with WebMock.disable_net_connect!)
WebMock.allow_net_connect!