# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/CyclomaticComplexity
# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/PerceivedComplexity

module Enumerable #:nodoc: all
  def my_each
    return to_enum unless block_given?

    arr = self.to_a if is_a? Range
    arr = self unless is_a? Range
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

  def my_select
    emp_arr = []
    return to_enum unless block_given?

    my_each do |n|
      emp_arr << n if yield(n)
    end
    emp_arr
  end

  def my_all?(param = nil)
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return false unless n.is_a? yield
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
    elsif !param.nil?
      if param.is_a? Class
        my_each do |n|
          return false unless n.is_a? param
        end
      elsif param.instance_of? Regexp
        my_each do |n|
          next if n =~ param

          return false
        end
      else
        my_each do |n|
          next if n == param

          return false
        end
      end
      true
    else
      return false if empty?

      my_each do |n|
        return false if n.nil? || n == false
      end
      true
    end
  end

  def my_any?(param = nil)
    if block_given?
      begin
        if (yield.is_a? Class) || (yield.instance_of? Regexp)
          my_each do |n|
            return true if (n.is_a? yield) || (n =~ yield)
          end
          false
        end
      rescue NoMethodError
        my_each do |n|
          return true if yield(n)
        end
        false
      end
    elsif !param.nil?
      my_each do |n|
        return true if (n.class == param) || (n =~ param) || (n == param)
      end
      false
    else
      return false if empty?

      my_each do |n|
        return true unless n.nil? || n == false
      end
      false
    end
  end

  def my_none?(param = nil)
    if block_given?
      begin
        if yield.is_a? Class
          my_each do |n|
            return false if n.is_a? yield
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
    elsif !param.nil?
      if param.is_a? Class
        my_each do |n|
          return false if n.is_a? param
        end
        true
      elsif param.instance_of? Regexp
        my_each do |n|
          return false if n =~ param
        end
        true
      else
        tester = true
        my_each do |n|
          tester = false if n == param
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

  def my_map(param = nil)
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
      arr = self.to_a if is_a? Range
      arr = self unless is_a? Range
      memo = arr.shift
      arr.my_each { |num| memo = memo.method(inivalue).call(num) }
      memo
    elsif !inivalue.nil? && inivalue.is_a?(Integer) && symbol.nil?
      my_each { |num| inivalue = yield(inivalue, num) }
      inivalue
    elsif inivalue.nil? && symbol.nil?
      arr = self.to_a if is_a? Range
      arr = self unless is_a? Range
      memo = arr.shift
      arr.my_each { |num| memo = yield(memo, num) }
      memo
    end
  end

  def multiply_els
    my_inject(:*)
  end
end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/MethodLength
# rubocop: enable Metrics/PerceivedComplexity
