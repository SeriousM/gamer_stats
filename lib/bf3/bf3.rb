require 'httparty'
require 'json'
require 'gamer_stats'

module GamerStats
  module Bf3
    class Player

      def initialize(name, platform, player = {})
        @name = name
        @platform = platform
        @player = player.deep_dup
      end

      def current
        get_current
      end

      def stats!
        raw_load
        get_current 'stats'
      end

      def stats
        raw_load unless loaded? 'stats'
        get_current 'stats'
      end

      def load!(opt='clear,global')
        raw_load(opt)
        get_current
      end

      def load(opt='clear,global')
        raw_load(opt) unless loaded?
        get_current
      end

      def kdr
        load
        return get_current('stats/global/kills').to_f / get_current('stats/global/deaths')
      end
      
    private

      def loaded?(path='')
        val = @player.path(path)
        false if val.nil? or val.empty?
      end

      def get_current(path='')
        @player.deep_dup.path(path)
      end

      def merge(player)
        @player.deep_merge player
      end

      def raw_load(opt='clear,global')
        body = {
          player: @name,
          output: 'json',
          opt: opt
        }

        begin
          response = HTTParty.post("http://api.bf3stats.com/#{@platform}/player/", :body => body, timeout: 5)
        rescue => e
          raise GamerStatsError, "Error on loading the player: #{e.message}"
        end
        
        if response.code == 200 && response['status'] == "data"
          @player = merge JSON(response.body)
        else
          raise GamerStatsError, "Bf3: #{response['error']}"
        end
      end
    end
  end
end
