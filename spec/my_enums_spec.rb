# frozen_string_literal: true

require_relative '../my_enums.rb'

RSpec.describe Enumerable do
  arr = [1,2,3,4,5]
  describe "#my_each" do
    it "Takes an array and executes a block for every item on the array" do
      expect(arr.my_each{|n| n}).to eq([1,2,3,4,5])
    end
  end
end

[11,22,31,224,44].my_each_with_index { |val,index| puts "index: #{index} for #{val}" if val < 30}