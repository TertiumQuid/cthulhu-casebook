require 'test_helper'

class ContestableSupportTest < ActiveModel::TestCase
  def setup
    @class = Challenge
    @instance = @class.new(:_id => 'first.last', :difficulty => 3)
  end
  
  def test_class_support
    [Challenge, Monster].each do |c|
      assert c.ancestors.include?(ActiveModel::ContestableSupport), "expected to be included in #{c}"
    end
  end
  
  def test_check_success
    assert_equal false, @instance.send(:check_success, 0, 100000, 0), 'expected failed check'
    assert_equal true, @instance.send(:check_success, 100000, 1, 0), 'expected successful check'    
  end
  
  def test_chance_of_success
    chance = @instance.send(:chance_of_success)
    assert_equal (50 - (@instance.difficulty * 10)), chance, 'expected modified chance of success'
  end
  
  def test_chance_of_success_with_tag
    tag = Tag.new(:value => 'test')
    chance = @instance.send(:chance_of_success)
    assert_equal (50 - (@instance.difficulty * 10)), chance, 'expected unmodified chance of success with non-numeric tag'
    
    tag = Tag.new(:value => 10)
    chance = @instance.send(:chance_of_success, tag)
    assert_equal (50 - (@instance.difficulty * 10) + tag.value.to_i), chance, 'expected modified chance of success with tag'
  end
end