require 'test_helper'

class ImportunityTest < ActiveModel::TestCase
  def setup
    @u1 = User.create(:email => 'u1@example.com')
    @u2 = User.create(:email => 'u2@example.com')
    @c1 = Character.create(:name => 'c1', :user => @u1)
    @c2 = Character.create(:name => 'c2', :user => @u2)    
  end
  
  def test_new_request
    importunity = nil
    assert_difference 'Importunity.count', +1 do
      importunity = Importunity.request(@u1, @u2._id)
    end
    assert_equal false, importunity.new?, 'expected importunity to be save'
    assert_equal importunity.user_id, @u2._id, 'expected user assigned'
    assert importunity.pending_user_ids.include?(@u1._id), 'expected sender assigned'
  end
  
  def test_existing_request  
    importunity = Importunity.create(:user_id => @u2._id)
    assert_no_difference 'Importunity.count' do
      assert_difference 'importunity.reload.pending_user_ids.count', +1 do
        assert_equal importunity, Importunity.request(@u1, @u2._id), 'expected existing importunity'
      end
    end
  end
  
  def test_request_with_pending_importunity
    importunity = Importunity.create(:user_id => @u2._id, :pending_user_ids => [@u1._id])
    
    assert_no_difference 'importunity.reload.pending_user_ids.count' do
      pending = Importunity.request(@u1, @u2._id)
      assert_not_nil pending.errors[:pending_user_ids], 'expected error on pending_user_ids'
    end
  end  
  
  def test_request_with_rejected_importunity  
    importunity = Importunity.create(:user_id => @u2._id, :rejected_user_ids => [@u1._id])
    
    assert_no_difference 'importunity.reload.pending_user_ids.count' do
      pending = Importunity.request(@u1, @u2._id)
      assert_not_nil pending.errors[:rejected_user_ids], 'expected error on rejected_user_ids'
    end    
  end
  
  def test_request_with_no_user
    missing = Importunity.request(@u1, 'fail')
    assert_not_nil missing.errors[:user_id], 'expected error on user_id'
  end
  
  def test_request_with_existing_friend
    @u2.update_attribute(:facebook_id, '123')
    @u1.update_attribute(:facebook_friend_ids, [@u2.facebook_id])
    assert_no_difference 'Importunity.count' do
      existing = Importunity.request(@u1, @u2._id)
      assert_not_nil existing.errors[:user_id], 'expected error on user_id'
    end    
  end  
  
  def test_message_user
    importunity = Importunity.new(:user_id => @u2._id)
    assert_difference ['Message.count','@u2.current_character.reload.messages.count'], +1 do
      message = importunity.message_user(@u1, @u2)
      
      assert message.text.include?("/characters/#{@u1.current_character._id}"), 'expected link to sender character'
      assert message.text.include?("/importunity/#{@u1._id}/accept"), 'expected link to accept'
      assert message.text.include?("/importunity/#{@u1._id}/reject"), 'expected link to reject'
      assert_equal @u1.current_character.name, message.sender, 'expected charcter name for sender'
      assert_equal @u2.current_character, message.character, 'expected assigned to recipient'      
    end
  end
  
  def test_message_rejected_user
    importunity = Importunity.new(:user_id => @u2._id)
    assert_difference 'Message.count', +1 do
      message = importunity.message_rejected_user(@u1._id)
      assert_equal @u1.current_character, message.character, 'expected assigned to recipient'      
    end
  end  
  
  def test_message_accepted_user
    importunity = Importunity.new(:user_id => @u2._id)
    assert_difference 'Message.count', +1 do
      message = importunity.message_accepted_user(@u1._id)
      assert_equal @u1.current_character, message.character, 'expected assigned to recipient'      
    end
  end  
  
  def test_accept
    importunity = Importunity.create(:user_id => @u1._id)    
    assert_no_difference 'importunity.reload.pending_user_ids.size', 'expected no difference for empty pending_user_ids' do
      importunity.accept!(@u2._id)
    end
    
    importunity.pending_user_ids << @u2._id.to_s
    importunity.save!
    assert_difference 'importunity.reload.pending_user_ids.size', -1 do
      importunity.accept!(@u2._id)
    end
  end
end