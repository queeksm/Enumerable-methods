# frozen_string_literal: true

module Enumerable #:nodoc: all
  def my_each
    return to_enum unless block_given?

    length.times do |n|
      current = self[n]
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
            return false unless n.instance_of? yield
          end
          true
        elsif yield.instance_of? Regexp
          my_each do |n|
            next if n =~ yield

            return false
          end
          true
        end
      rescue NoMethodError
        my_each do |n|
          next if yield(n)

          return false
        end
        true
      end
    else
      return false if empty?

      my_each do |n|
        return false if n.nil? || n == false
      end
      true
    end
  end

  def my_any?
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return true if n.instance_of? yield
          end
          false
        elsif yield.instance_of? Regexp
          my_each do |n|
            return true if n =~ yield
          end
          false
        end
      rescue NoMethodError
        my_each do |n|
          return true if yield(n)
        end
        false
      end
    else
      return false if empty?

      my_each do |n|
        return true unless n.nil? || n == false
      end
      false
    end
  end

  def my_none?
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return false if n.instance_of? yield
          end
          true
        elsif yield.instance_of? Regexp
          my_each do |n|
            return false if n =~ yield
          end
          true
        end
      rescue NoMethodError
        tester = true
        my_each do |n|
          tester = false if yield(n)
          break if tester == false
        end
        tester
      end
    else
      return true if empty?

      my_each do |n|
        return false if n == true
      end
      true
    end
  end

  def my_count(item = 'CANTOR')
    count = 0
    if block_given?
      my_each do |n|
        count += 1 if yield(n)
      end
    elsif item == 'CANTOR'
      count = length
    else
      my_each do |n|
        count += 1 if n == item
      end
    end
    count
  end

  def my_map_one
    return to_enum unless block_given?

    emp_arr = []
    my_each do |n|
      emp_arr << yield(n)
    end
    emp_arr
  end

  def my_map_two(proc = nil)
    return to_enum if proc.nil?

    emp_arr = []
    my_each do |n|
      emp_arr << proc.call(n)
    end
    emp_arr
  end

  def my_map_three(param = nil)
    emp_arr = []
    my_each do |n|
      if param.nil? && block_given?
        emp_arr << yield(n)
      elsif !param.nil? && !block_given?
        emp_arr << param.call(n)
      elsif !param.nil? && block_given?
        emp_arr << param.call(n)
      else
        return to_enum
      end
    end
    emp_arr
  end

  def my_inject(inivalue = nil, symbol = nil)

    if !inivalue.nil? && !symbol.nil?
      my_each { |num| inivalue = inivalue.method(symbol).call(num) }
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
