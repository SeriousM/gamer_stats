require_relative '../test_helper'

describe Bf3::Player do

  let(:player) { Bf3::Player.new 'SeriousM', 'pc' }
  let(:non_player) { Bf3::Player.new 'xx', 'xx' }

  describe 'getting a player' do
    it 'should return the player requested' do
      stats = player.load
      stats['country'].wont_be_nil
    end
  end

  describe 'getting a player\'s stats' do
    it 'should return the player requested' do
      stats = player.stats
      stats.wont_be_nil
    end

    it 'should have some global stats' do
      player.load('clear,global')
      player.current['stats']['global'].wont_be_nil
    end
  end

  describe 'some vanity stats' do
    it 'should return a floating point kill to death ratio' do
      kdr = player.kdr
      kdr.wont_be_nil
      kdr.must_be_instance_of(Float)
    end
  end

  describe 'will throw an error when the player does not exist' do
    it 'on load' do
      ->{ non_player.load }.must_raise GamerStatsError
    end
  end
end