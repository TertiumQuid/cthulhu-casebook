class Message
  include MongoMapper::Document
  
  key :sender, String, :required => true
  key :title, String, :required => true
  key :text, String, :required => true
  
  belongs_to :character
  
  after_create :update_character_messages_count
  
  def self.find_readable(character, message_id=nil)
    q = where '$or' => [{:character_id => character._id}, {:character_id => nil}, {:character_id => {'$exists' => false}}]
    q = q.first(:_id => message_id) if message_id
    q
  end  
  
  private 
  
  def update_character_messages_count
    character.update_attribute(:messages_count, character.messages_count + 1) if character
  end
end