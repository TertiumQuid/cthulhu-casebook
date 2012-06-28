require 'test_helper'

class GiftTest < ActiveModel::TestCase
  def setup
    @c1 = Character.create(:name => 'c1')
    @c2 = Character.create(:name => 'c2')
  end
  
  def test_give
    assert_no_difference 'Gift.count', 'expected gift if not possessed' do
      gift = Gift.give(@c1, @c2._id, 'test.fail')
      assert_not_nil gift.errors[:sender_id], 'expected error on sender_id'
    end
    
    @c2.relocate!('arkham_rivertown')
    assert_no_difference 'Gift.count', 'expected no clues from different locations' do
      gift = Gift.give(@c1, @c2._id, 'belongings.american_dollars')
      assert_not_nil gift.errors[:recipient_id], 'expected error on character_ids'
    end    
    @c2.relocate!(@c1.location.value)
    
    assert_difference "Message.count", +1 do
      assert_difference "@c1.reload.profile.get('belongings', 'american_dollars').value.to_i", -1 do      
        Gift.give(@c1, @c2._id, 'belongings.american_dollars')        
      end
    end
  end
    
  def test_accept
    gift = Gift.give(@c1, @c2._id, 'belongings.american_dollars')
    assert_difference "@c2.reload.profile.get('belongings', 'american_dollars').value.to_i", +1 do    
      assert_difference 'Gift.count', -1 do      
        gift.accept!
      end      
    end
  end
  
  def test_reject
    gift = Gift.give(@c1, @c2._id, 'belongings.american_dollars')
    assert_difference 'Gift.count', -1 do
      gift.reject!
    end
  end  
    
  def test_message_character
    gift = Gift.new(:sender => @c1, :recipient => @c2, :item => 'test.test')
    assert_difference ['Message.count','@c2.reload.messages.count'], +1 do
      message = gift.message_character

      assert message.text.include?("/characters/#{@c1._id}"), 'expected link to sender character'
      assert message.text.include?("/gifts/#{gift._id}/accept"), 'expected link to accept'
      assert message.text.include?("/gifts/#{gift._id}/reject"), 'expected link to reject'
      assert_equal @c1.name, message.sender, 'expected charcter name for sender'
      assert_equal @c2, message.character, 'expected assigned to recipient'      
    end
  end
end