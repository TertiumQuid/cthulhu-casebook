require 'test_helper'

class TagTest < ActiveModel::TestCase
  def test_set_numeric
    tag = Tag.new
    tag.set(10)
    assert_equal '10', tag.value, 'expected value to be set to given number'
    tag.set('2')
    assert_equal '12', tag.value, 'expected value to be added to number'
  end
  
  def test_set_text
    tag = Tag.new
    tag.set('test')    
    assert_equal 'test', tag.value, 'expected value to be set to given string'
  end  
  
  def test_numeric_with_value
    tag = Tag.new
    assert_equal false, tag.send(:numeric?), 'expected false for nil value'
    tag.value = 'test'
    assert_equal false, tag.send(:numeric?), 'expected false for string value'
    tag.value = '111'
    assert_equal true, tag.send(:numeric?), 'expected true for numeric string value'
    tag.value = 111
    assert_equal true, tag.send(:numeric?), 'expected true for numeric value'    
  end
  
  def test_numeric_with_param  
    tag = Tag.new
    tag.value = 1
    assert_equal false, tag.send(:numeric?, 'test'), 'expected false for override with string'
  end  
end