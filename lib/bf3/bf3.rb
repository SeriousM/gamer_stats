require 'httparty'
require 'json'
require 'p_stats'

module PStats
  module Bf3
    class Player

      def initialize(name, platform)
        @name = name
        @platform = platform
      end

      def stats!(opt='clear,global')
        @stats = load(opt)['stats']
      end

      def stats(opt='clear,global')
        @stats ||= stats!(opt)
      end

      def load!(opt='clear,global')
        @player_stats = raw_load(opt)
      end

      def load(opt='clear,global')
        @player_stats ||= load!(opt)
      end

      def kdr
        stats() unless @stats and @stats['global']['kills']
        return @stats['global']['kills'].to_f / @stats['global']['deaths']
      end
      
    private

      def raw_load(opt='clear,global')
        body = {
          player: @name,
          output: 'json',
          opt: opt
        }

        begin
          response = HTTParty.post("http://api.bf3stats.com/#{@platform}/player/", :body => body, timeout: 5)
        rescue => e
          raise PStatsError, "Error on loading the player: #{e.message}"
        end
        
        if response.code == 200 && response['status'] == "data"
          JSON(response.body)
        else
          raise PStatsError, "Bf3: #{response['error']}"
        end
      end
    end
  end
end
