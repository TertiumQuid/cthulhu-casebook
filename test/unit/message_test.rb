require 'test_helper'

class MessageTest < ActiveModel::TestCase
  def test_update_character_messages_count
    character = Character.create(:name => 'test')
    message = Message.new(:character => character)
    message.send(:update_character_messages_count)
    assert_equal 1, character.reload.messages_count, 'expected message count of 1 after message creation'
    
    assert_nothing_raised 'expected characterless messages allowed' do
      message = Message.new
      message.send(:update_character_messages_count)
    end
  end
  
  def test_find_readable
    character = Character.new(:_id => 'test')
    Message.create!(:type => 'type', :title => 'title', :text => 'text', :sender => 'sender')
    message = Message.create!(:type => 'type', :title => 'title', :text => 'text', :sender => 'sender', :character => character)    
    messages = Message.find_readable(character).all
    assert_equal [message], messages, 'expected all and only messages for character'
  end
end