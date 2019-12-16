# frozen_string_literal: true

module Enumerable
  def my_each
    self.length.times do |n|
      current = self[n]
      yield(current)
    end
  end

  def my_each_with_index
    self.length.times do |n|
      index = n
      current = self[n]
      yield(index,current)
    end
  end

  def my_select
    emp_arr = []
    self.my_each do |n|
      emp_arr << n if yield(n)
    end
    return emp_arr
  end

  def my_all?
    emp_arr = []
    self.my_each do |n|
      emp_arr << n if yield(n)
    end
    return emp_arr == self ? true : false
  end

  def my_any?
    tester = false
    self.my_each do |n|
      tester = true if yield(n)
      break if tester
    end 
    return tester
  end

  def my_none?
    tester = true
    self.my_each do |n|
      tester = false if yield(n)
      break if tester == false
    end
    return tester
  end

  def my_count(item = "CANTOR")
    count = 0
    if item == "CANTOR"
      self.my_each do |n|
        count += 1
      end
    else
      self.my_each do |n|
        count += 1 if n == item
      end
    end
    return count
  end

  def my_map_one
    emp_arr = []
    self.my_each do |n|
      if yield(n)
        emp_arr << true
      else
        emp_arr << false
      end
    end
    return emp_arr
  end

  def my_map_two(&block)
    emp_arr = []
    self.my_each do |n|
      emp_arr << block.call(n)
    end
    emp_arr
  end


  def my_map_three(param = nil)
    emp_arr = []
    self.my_each do |n|
      if param == nil && block_given?
        emp_arr << yield(n)
      elsif param != nil && block_given?
        emp_arr << param.call(n)
      end
    end
    emp_arr
  end

  def my_inject(inivalue = nil, symbol = nil)
    if inivalue != nil && symbol != nil
      self.my_each{ |num| inivalue.method(symbol).call(num)}
      inivalue
    elsif inivalue != nil && inivalue.is_a?(Symbol) && symbol == nil
      memo, *remaining_elements = self
      remaining_elements.my_each { |num| memo = memo.method(inivalue).call(num) }
      memo
    elsif inivalue != nil && inivalue.is_a?(Integer) && symbol == nil
      self.my_each { |num| inivalue = yield(inivalue, num) }
      inivalue
    elsif inivalue == nil && symbol == nil
      inivalue, *remaining_elements = self
      remaining_elements.my_each { |num| inivalue = yield(inivalue, num) }
      inivalue
    end
  end
end


  

  