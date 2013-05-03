require 'httparty'
require 'json'
require 'p_stats'

module PStats
  module Bf3
    class Player

      def initialize(name, platform, player = [])
        @name = name
        @platform = platform
        @player = player
      end

      def stats!()
        raw_load
        @player['stats']
      end

      def stats()
        raw_load if @player['stats'].empty?
        @player['stats']
      end

      def load!()
        raw_load
        @player
      end

      def load()
        raw_load if @player.empty?
        @player
      end

      def kdr
        return stats['global']['kills'].to_f / stats['global']['deaths']
      end
      
    private

      def merge(player)
        @player.deep_merge! player
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
          raise PStatsError, "Error on loading the player: #{e.message}"
        end
        
        if response.code == 200 && response['status'] == "data"
          merge JSON(response.body)
        else
          raise PStatsError, "Bf3: #{response['error']}"
        end
      end
    end
  end
end
