# frozen_string_literal: true

module Enumerable #:nodoc: all
  def my_each
    return to_enum unless block_given?

    length.times do |n|
      current = self[n]
      yield(current)
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    my_each do |n|
      yield(n, self.index(n))
    end
  end

  def my_select
    emp_arr = []
    return to_enum unless block_given?
    my_each do |n|
      emp_arr << n if yield(n)
    end
    emp_arr
  end

  def my_all?
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return false if !n.instance_of? yield
          end
          true
        elsif yield.instance_of? Regexp
          my_each do |n|
            next if n =~ yield
            return false
          end
          true
        end
      rescue => exception
        my_each do |n|
          next if yield(n)
          return false
        end
        return true
      end
    else
      return false if self.length == 0
      my_each do |n|
        return false if n.nil? || n == false
      end
      return true
    end
  end

  def my_any?
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            if n.instance_of? yield
              return true
            else
              next
            end
          end
          return false
        elsif yield.instance_of? Regexp
          my_each do |n|
            if n =~ yield
              return true
            else
              next
            end
          end
          return false
        end
      rescue => exception
        my_each do |n|
          if yield(n)
            return true
          else
            next
          end
        end
      return false
      end
    else
      return false if self.length == 0
      my_each do |n|
        if n.nil? || n == false
          next
        else
          return true
        end
      end
      return false
    end
  end

  def my_none?
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return false if n.instance_of? yield
          end
          return true
        elsif yield.instance_of? Regexp
          my_each do |n|
            return false if n =~ yield
          end
          return true
        end
      rescue => exception
        tester = true
        my_each do |n|
          tester = false if yield(n)
          break if tester == false
        end
      tester
      end
    else
      return true if self.length == 0
      my_each do |n|
        return true if n.nil? || n == false
      end
      return false
    end
  end

  def my_count(item = 'CANTOR')
    count = 0
    if block_given?
      my_each do |n|
        count += 1 if yield(n)
      end
      count
    else
      if item == 'CANTOR'
        count = length
      else
        my_each do |n|
          count += 1 if n == item
        end
      end
      count
    end
  end

  def my_map_one
    return enum = self.to_enum unless block_given?    
    emp_arr = []
    my_each do |n|
      emp_arr << yield(n)
    end
    emp_arr
  end

  def my_map_two(&block)
    emp_arr = []
    my_each do |n|
      emp_arr << block.call(n)
    end
    emp_arr
  end

  def my_map_three(param = nil)
    emp_arr = []
    my_each do |n|
      if param.nil? && block_given?
        emp_arr << yield(n)
      elsif !param.nil? && block_given?
        emp_arr << param.call(n)
      end
    end
    emp_arr
  end

  def my_inject(inivalue = nil, symbol = nil)
    if !inivalue.nil? && !symbol.nil?
      my_each { |num| inivalue.method(symbol).call(num) }
      inivalue
    elsif !inivalue.nil? && inivalue.is_a?(Symbol) && symbol.nil?
      memo, *rem_elements = self
      rem_elements.my_each { |num| memo = memo.method(inivalue).call(num) }
      memo
    elsif !inivalue.nil? && inivalue.is_a?(Integer) && symbol.nil?
      my_each { |num| inivalue = yield(inivalue, num) }
      inivalue
    elsif inivalue.nil? && symbol.nil?
      inivalue, *rem_elements = self
      rem_elements.my_each { |num| inivalue = yield(inivalue, num) }
      inivalue
    end
  end

  def multiply_els
    my_inject(:*)
  end
end


