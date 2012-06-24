class Character
  include MongoMapper::Document
  
  key :name, String, :required => true
  key :clues, Integer, :required => true, :default => 100
  key :gender, String
  key :messages_count, Integer, :default => 1
  
  belongs_to :user
  belongs_to :monster  
  has_one    :profile
  has_many   :messages
  
  after_create :populate_profile
  
  def self.find_for_users(user_ids)
    where(:user_id => {'$in' => user_ids} )
  end
  
  def self.new_for_user(params)
    params ||= {}
    params[:user_id] ||= User.create(:email => "#{rand(1000000)}@example.com")._id
    Character.new params
  end
  
  def spend_clues(amount=1)
    self.clues = self.clues - amount
  end
  
  def encounter_monster!(monster_id)
    self.monster_id = monster_id
    save
  end
  
  def fighting_monster?
    !monster_id.blank?
  end
  
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