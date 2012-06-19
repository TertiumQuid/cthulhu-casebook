require 'test_helper'

class UserTest < ActiveModel::TestCase
  def setup
    @user = User.create(:email => 'test@example.com')
  end
  
  def test_current_character
    assert_nil @user.current_character, 'expected no associated character'
    
    first = @user.characters.create(:name => 'first')
    last = @user.characters.create(:name => 'last')    
    assert_equal last, @user.current_character, 'expected last character to be current'
  end
end