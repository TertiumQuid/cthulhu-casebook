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
  
  def test_facebook_friends
    facebook_id = 'test'
    assert_nil @user.facebook_friends, 'expected no default facebook friends'
    
    @user.update_attribute(:facebook_id, facebook_id)
    user = User.create(:email => 'friend@example.com', 'facebook_friend_ids' => [facebook_id])
    assert_equal [user], @user.facebook_friends.all, 'expected user with fb id found among friends'
  end
  
  def test_befriend
    assert_no_difference '@user.facebook_friend_ids.size', 'expected no friends for nil user' do
      @user.befriend!(nil)
    end
    user = User.create!(:email => 'friend@example.com', :facebook_id => '123')
    assert_difference '@user.reload.facebook_friend_ids.size', +1, 'expected friend added to friend ids' do
      @user.befriend!(user)
    end
    assert @user.reload.facebook_friend_ids.include?(user.facebook_id), 'expected facebook friend added to friend ids'
    assert_no_difference '@user.reload.facebook_friend_ids.size', 'expected duplicate friend id prevented' do
      @user.befriend!(user)
    end
  end
end