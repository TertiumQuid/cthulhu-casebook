require 'test_helper'

class MessageTest < ActiveModel::TestCase
  def setup
    @character = Character.create(:name => 'test')
  end
  
  def test_update_character_messages_count
    count = @character.messages_count
    message = Message.new(:character => @character)
    assert_difference '@character.reload.messages_count', 1, 'expected message count incremented' do
      message.send(:update_character_messages_count)
    end
    
    assert_nothing_raised 'expected characterless messages allowed' do
      message = Message.new
      message.send(:update_character_messages_count)
    end
  end
  
  def test_find_all_readable
    global_message = Message.create!(:title => 'title', :text => 'text', :sender => 'sender')
    hidden_message = Message.create!(:title => 'title', :text => 'text', :sender => 'sender', :character => Character.new)
    personal_message = Message.create!(:title => 'title', :text => 'text', :sender => 'sender', :character => @character)    
    
    messages = Message.find_readable(@character).all
    assert_equal [global_message, personal_message], messages, 'expected all and only personal or global messages'
  end
  
  def test_find_one_readable
    message = Message.create!(:title => 'title', :text => 'text', :sender => 'sender', :character => @character)    
    
    match = Message.find_readable(@character, message._id)
    assert_equal message, match, 'expected message found by id'
  end  
end