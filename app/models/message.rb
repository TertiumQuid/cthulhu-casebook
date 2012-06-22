class Message
  include MongoMapper::Document
  
  key :type, String, :required => true
  key :sender, String, :required => true
  key :title, String, :required => true
  key :text, String, :required => true
  
  belongs_to :character
  
  after_create :update_character_messages_count
  
  def self.find_readable(character)
    where(:character_id => character._id)
  end  
  
  private 
  
  def update_character_messages_count
    character.update_attribute(:messages_count, character.messages_count + 1) if character
  end
end