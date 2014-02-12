require "test/unit"

# http://codekata.com/kata/kata09-back-to-the-checkout/

#  Rules:
#  Item   Unit      Special
#         Price     Price
# --------------------------
#   A     50       3 for 130
#   B     30       2 for 45
#   C     20
#   D     15

class CheckOut
  
  attr_accessor :total

  def initialize(rules)
    @@rules = rules
    @individual_items = {}
   
   

  end

  def scan(item)
    #checklist of the items
    if @individual_items.has_key?(item)
        @individual_items[item] += 1
    else
      @individual_items[item] = 1
    end

  end

  def total
    # return the total price using only the hash
   sum = 0
   
    @individual_items.each do |key, value|
       
      unit_prices = @@rules[key] 
        
      if unit_prices.has_key?(value.to_s)
        sum = sum +  unit_prices[value.to_s].to_i
      
      else
        max_unit_size = unit_prices.keys.max.to_i

        if value > max_unit_size 
          sum_first = value/max_unit_size * unit_prices[max_unit_size.to_s].to_i 
          remainder = value%max_unit_size
          item =  unit_prices.keys.reverse.find{|i| remainder > i.to_i}
          sum_second =  unit_prices[item].to_i * remainder
          total = sum_first + sum_second
          sum = sum + total
        else
          item =  unit_prices.keys.reverse.find{|i| value > i.to_i}
          total = unit_prices[item].to_i * value
          sum = sum + total
        end

    end
  end
    return sum
  end

 

  
end




class TestPrice < Test::Unit::TestCase
  RULES = { "A" => {"1" => 50, "3" => "130"},  
            "B" => {"1" => 30, "2" => "45"}, 
            "C" => {"1" => 20}, 
            "D" => {"1" => 15}
          }
  def price(goods)
    
    
    co = CheckOut.new(RULES)

    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end