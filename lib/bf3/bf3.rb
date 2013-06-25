require 'httparty'
require 'json'
require 'yaml'
require 'gamer_stats'
require 'helper/zip'

module GamerStats
  module Bf3
    class Player
      
      def self.parse(stream)
        new(JSON(stream))
      end

      def self.load(platform, name)
        new.initial_load(platform, name)
      end

      def name
        @player["name"]
      end

      def platform
        @player["plat"]
      end

      def to_yaml
        @player.to_yaml
      end

      def to_s
        @player.to_s
      end

    private

      def initialize(player = {})
        @player = player.deep_dup
      end

      def load_data_def
        data_def_path = "#{File.expand_path(File.dirname(__FILE__))}/../res/bf3.datadef.gz"
        file_content = Util::Zip.ungzip(data_def_path)
        JSON.parse(file_content)
      end

      def initial_load(platform, name)
        @player = load_data_def
        local_player = raw_load('clear,raw,nozero,dogtags,imgInfo,nextranks')
        easy_merge local_player
        dogtag_merge local_player
        nextrank_merge local_player
        key_merge local_player
      end

      def easy_merge(from)
        ["plat","name","tag","language","country",
         "country_name","country_img",
         "date_insert","date_update"].each do |key|
          
          @player[key] = from[key]
        end

        to[status]
      end

      def dogtag_merge(from)
        ["basic","advanced"].each do |cat|
          ["name","desc","license","image_l","image_s"].each do |key|
            @player["dogtag"][cat][key] = from["dogtag"][cat][key]
          end
        end
      end

      def nextrank_merge(from)
        @player["stats"]["nextranks"] = from["stats"]["nextranks"]
      end

      def key_merge(from)
        player_string = @player.to_yaml

        ["stat","coop"].each do |cat|
          from[cat].each_pair do |key, value|
            player_string.sub! "#{cat}.#{key}", value
          end
        end

        @player = YAML.load(player_string)
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
