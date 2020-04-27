module Enumerable
  def my_each
    return to_enum unless block_given?
    arr = self.to_a if self.is_a? Range
    arr = self unless self.is_a? Range    
    arr.length.times do |n|
    current = arr[n]
    yield(current)
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    my_each do |n|
      yield(n, index(n))
    end
    self
  end
end

p [0,11,22,31,224,44].my_each_with_index { |val,index| puts "index: #{index} for #{val}" if val < 12}