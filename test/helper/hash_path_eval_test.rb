require_relative '../test_helper'

describe Hash do
  let(:h_empty) { {} }
  let(:h_string) { { 'a' => { 'b' => { 'c' => 1 } } } }
  let(:h_symbol) { { a: { b: { c: 1 } } } }
  let(:h_mixed) { { a: { 'b' => { c: 1 } } } }

  it "returns hash without a path specified" do
    h_empty.path(nil).wont_be_nil
  end

  it "returns hash on nil path" do
    h_empty.path(nil).wont_be_nil
  end
  
  it "returns hash on empty path" do
    h_empty.path('').wont_be_nil
  end
  
  it "works with pure string hash" do
    h_string.path('a/b/c').must_equal 1
  end
  
  it "works with pure symbol hash" do
    h_symbol.path(':a/:b/:c').must_equal 1
  end
  
  it "works with a mixed hash" do
    h_mixed.path(':a/b/:c').must_equal 1
  end
  
  it "return nil on non existing path" do
    h_mixed.path(':a/x/:c').must_be_nil
  end
end