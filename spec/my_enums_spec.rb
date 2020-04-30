# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/BlockLength
# rubocop:disable Style/SymbolProc
# rubocop:disable Style/Proc

require_relative '../my_enums.rb'

RSpec.describe Enumerable do
  arr = [1, 2, 3, 4, 5]

  describe '#my_each' do
    emp = []
    it 'Takes an array and executes a block for every item on the array returns the array itself' do
      arr.my_each do |n|
        emp << n + 2
      end
      expect(emp).to eq([3, 4, 5, 6, 7])
    end

    it 'Return Enum if no block is passed' do
      expect(arr.my_each).to be_kind_of(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    index = 0
    it 'is used to Iterate over the object with its index and returns value of the given object' do
      arr.my_each_with_index do |num, idx|
        index = idx if num > 4
      end
      expect(index).to eq(4)
    end

    it 'returns an enumerable when no block is passed' do
      expect(arr.my_each_with_index).to be_kind_of(Enumerator)
    end
  end

  describe '#my_select' do
    emp = []
    it 'returns a new array with all the elements that fulfill the block condition' do
      arr.my_select do |n|
        emp << n if n.even?
      end
      expect(emp).to eq([2, 4])
    end

    it 'returns an enum when a block its not given' do
      expect(arr.my_select).to be_kind_of(Enumerator)
    end
  end

  describe '#my_all?' do
    arr_test = %w[new dent can]
    arr_test2 = [true, nil, 9, 'f']
    it 'Returns true if all the members of the array fit the condition on the block' do
      expect(arr.my_all? { |n| n < 6 }).to eq(true)
    end

    it 'Returns true if all the members of the array fit the condition on the block' do
      expect(arr.my_all? { Integer }).to eq(true)
    end

    it 'Returns true if all the members of the array fit the condition on the block' do
      expect(arr_test.my_all? { /n/ }).to eq(true)
    end

    it 'Returns true for an empty array' do
      expect([].my_all?).to eq(true)
    end

    it 'If no block is passed then returns true iff all the object within the array are true' do
      expect(arr_test2.my_all?).to eq(false)
    end

    it 'If no block is passed then returns true iff all the object within the array are true' do
      expect(arr_test.my_all?).to eq(true)
    end
  end

  describe '#my_any?' do
    arr_test = %w[new dent can]
    arr_test2 = [true, nil, 9, 'f']
    it 'Returns true if any of the object within the array fit the condition' do
      expect(arr.my_any? { |n| n .even? }).to eq(true)
    end

    it 'Returns true if any of the object within the array fit the condition' do
      expect(arr.my_any? { Integer }).to eq(true)
    end

    it 'Returns true if any of the object within the array fit the condition' do
      expect(arr_test2.my_any?(/f/) ).to eq(true)
    end

    it 'If no block is passed it returns true if any of the elements is true or not nil' do
      expect(arr_test2.my_any?).to eq(true)
    end

    it 'Returns false when apllied to an empty array' do
      expect([].my_any?).to eq(false)
    end
  end

  describe '#my_none?' do
    arr_test = %w[new dent can]
    arr_test2 = [true, nil, 9, 'f']
    it 'Passes each element of the collection to the given block. The method returns true if the block never returns true for all elements.' do
      expect(arr.my_none? { |n| n > 10 }).to eq(true)
    end

    it 'Passes each element of the collection to the given block. The method returns true if the block never returns true for all elements.' do
      expect(arr.my_none? { String }).to eq(true)
    end

    it 'Passes each element of the collection to the given block. The method returns true if the block never returns true for all elements.' do
      expect(arr_test.my_none? { /q/ }).to eq(true)
    end

    it 'If no block is given it will return false if any of the memebrs of the collection is true' do
      expect(arr_test2.my_none?).to eq(false)
    end

    it 'Returns true if applied to an empty array' do
      expect([].my_none?).to eq(true)
    end
  end

  describe '#my_count' do
    it 'Return the number of item within the collection' do
      expect(arr.my_count).to eq(5)
    end

    it 'If a value is given it returns the amount of items equal to the value given' do
      expect(arr.my_count(2)).to eq(1)
    end

    it 'if a block is given it return the number of values that are true within the block' do
      expect(arr.my_count { |n| n <= 3 }).to eq(3)
    end
  end

  describe '#my_map_one' do
    it 'Returns an array after transforming the data with the black given' do
      expect(arr.my_map_one { |n| n * 2 }).to eq([2, 4, 6, 8, 10])
    end

    it 'Returns an enumerator when no block is passed' do
      expect(arr.my_map_one).to be_kind_of(Enumerator)
    end
  end

  describe '#my_map_two' do
    it 'Returns a transformed array after recieving a proc as a parameter' do
      test = Proc.new { |n| n * 2 }
      expect(arr.my_map_two(test)).to eq([2, 4, 6, 8, 10])
    end

    it 'Returns an enum if no parameter is given' do
      expect(arr.my_map_two).to be_kind_of(Enumerator)
    end
  end

  describe '#my_map_three' do
    test = Proc.new { |n| n * 2 }
    it 'Returns a transformed array after receiving a proc as a parameter' do
      expect(arr.my_map_three(test)).to eq([2, 4, 6, 8, 10])
    end

    it 'Returns a transformed array after receiving a block' do
      expect(arr.my_map_three { |n| n + 2 }).to eq([3, 4, 5, 6, 7])
    end

    it 'executes the proc if a proc and a block are given' do
      expect(arr.my_map_three(test) { |n| n + 2 }).to eq([2, 4, 6, 8, 10])
    end

    it 'Returns a enum when nor a block or a proc are given' do
      expect(arr.my_map_three).to be_kind_of(Enumerator)
    end
  end

  describe '#my_inject' do
    it 'Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      expect(arr.my_inject(:*)).to eq(120)
    end

    it 'Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      expect(arr.my_inject(2, :*)).to eq(240)
    end

    it 'Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      expect(arr.my_inject { |product, n| product * n }).to eq(120)
    end

    it 'Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      expect(arr.my_inject(2) { |product, n| product * n }).to eq(240)
    end

    it 'Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator.' do
      longest = %w[cat sheep bear].inject do |memo, word|
        memo.length > word.length ? memo : word
      end
      expect(longest).to eq('sheep')
    end
  end
end

# rubocop:enable Metrics/LineLength
# rubocop:enable Metrics/BlockLength
# rubocop:enable Style/SymbolProc
# rubocop:enable Style/Proc
