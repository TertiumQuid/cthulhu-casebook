class Character
  include MongoMapper::Document
  
  key :name, String, :required => true
  key :moxie, Integer, :required => true, :default => 100
  key :gender, String
  
  belongs_to :user
  has_one :profile
  
  after_create :populate_profile
  
  def location
    profile.get('location', 'current') if profile
  end
  
  private 
  
  def populate_profile
    self.profile = Profile.create(:character => self)
  end
end