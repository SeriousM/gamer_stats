require 'httparty'
require 'json'
require 'gamer_stats'

module GamerStats
  module Bf3
    class Player
      class << self
        def parse(stream)
          new(JSON(stream))
        end

        def load(platform, name)
          new.initial_load(platform, name)
        end

        private :new
      end

      def initialize(player = {})
        @player = player.deep_dup
      end

      def name
        @player["name"]
      end

      def platform
        @player["plat"]
      end

    private

      def load_data_def
        data_def_path = "#{File.expand_path(File.dirname(__FILE__))}/../res/bf3.datadef"
        JSON.parse(IO.read(data_def_path))
      end

      def initial_load(platform, name)
        @player = load_data_def
        local_player = raw_load('clear,raw,nozero,dogtags,imgInfo')
        extract_base_data local_player
        easy_merge local_player
        key_merge local_player
      end

      def extract_base_data(player)
        player_copy = player.deep_dup
        player_copy.delete "stat"
        player_copy.delete "coop"

        # todo: copy basic info here
      end

      def key_merge(player)
        # todo: do a merge with player-key to @player-data-hash
      end

      def raw_load(opt='clear')
        body = {
          player: name,
          output: 'json',
          opt: opt
        }

        begin
          response = HTTParty.post("http://api.bf3stats.com/#{platform}/player/", :body => body, timeout: 5)
        rescue => e
          raise GamerStatsError, "Error on loading the player: #{e.message}"
        end
        
        if response.code == 200 && response['status'] == "data"
          JSON(response.body)
        else
          raise GamerStatsError, "Bf3: #{response['error']}"
        end
      end
    end
  end
end
