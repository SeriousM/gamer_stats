require 'p_stats'
require 'minitest/spec'
require 'minitest/autorun'

include PStats

describe Bf3::Player do
  before do
    @player = Bf3::Player.new('SeriousM', 'pc')
    @non_player = Bf3::Player.new('xx', 'xx')
  end

  describe 'getting a player' do
    it 'should return the player requested' do
      soldier = @player.load()
      soldier['country'].wont_be_nil
    end
  end

  describe 'getting a player\'s stats' do
    it 'should return the player requested' do
      soldier = @player.load()
      soldier['stats'].wont_be_nil
    end
    it 'should have some global stats' do
      soldier = @player.stats('clear,rank')
      soldier['global'].must_be_nil
      soldier['rank'].wont_be_nil
    end
  end

  describe 'some vanity stats' do
    it 'should return a floating point kill to death ratio' do
      kdr = @player.kdr()
      kdr.wont_be_nil
      kdr.must_be_instance_of(Float)
    end
  end

  describe 'will throw an error when the player does not exist' do
    it 'on load' do
      ->{@non_player.load}.must_raise PStatsError
    end
  end
end