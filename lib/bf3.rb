require "p_stats/version"
require 'httparty'
require 'json'

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

      def load(opt='clear,global')
        @player_stats ||= load!(opt)
      end

      def load!(opt='clear,global')
        body = {
          player: @name,
          output: 'json',
          opt: opt
        }
        response = HTTParty.post("http://api.bf3stats.com/#{@platform}/player/", :body => body)
        
        if response.code == 200 && response['status'] == "data"
          player_stats = JSON(response.body)
          @player_stats = player_stats
        else
          raise ArgumentError, "Bf3: #{response['error']}"
        end
      end

      def kdr
        stats() unless @stats and @stats['global']['kills']
        return @stats['global']['kills'].to_f / @stats['global']['deaths']
      end
      
    end
  end
end
