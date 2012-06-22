class Character
  include MongoMapper::Document
  
  key :name, String, :required => true
  key :moxie, Integer, :required => true, :default => 100
  key :gender, String
  key :messages_count, Integer, :default => 0
  
  belongs_to :user
  has_one    :profile
  has_many   :messages
  
  after_create :populate_profile
  
  def location
    profile.get('location', 'current') if profile
  end
  
  def reset_messages_count
    return if messages_count == 0
    
    self.messages_count = 0
    self.save
  end
  
  private 
  
  def populate_profile
    self.profile = Profile.create(:character => self)
  end
end