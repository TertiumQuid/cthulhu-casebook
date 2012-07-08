class Character
  include MongoMapper::Document
  
  MAX_CLUES = 50
  
  key :name, String, :required => true
  key :clues, Integer, :required => true, :default => MAX_CLUES
  key :gender, String
  key :biography, String  
  key :messages_count, Integer, :default => 1
  key :character_friend_ids, Array  
  key :last_seen_at, Time
    
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
  
  def self.reclue
    Character.set({:clues => {'$lt' => MAX_CLUES}}, :clues => MAX_CLUES)
  end
  
  def friends
    character_friend_ids.blank? ? [] : Character.where(:_id => {'$in' => character_friend_ids })
  end  
  
  def local_friends
    if character_friend_ids.blank?
      []
    else
      friends = Profile.where('character_id' => {'$in' => character_friend_ids} )
      friends = friends.where('taggings._id' => 'location', 'taggings.tags' => {:_id => 'current', :value => location.value})
      friends = friends.map{ |p| p.character }
      friends = friends.select{ |c| c.last_seen_at && c.last_seen_at >= (Time.now.utc - 6.hours) }
      friends
    end
  end
  
  def spend_clues(amount=1)
    self.clues = self.clues - amount
    self.last_seen_at = Time.now.utc
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
  
  def lodgings
    profile.get('lodgings', 'current') if profile
  end  
  
  def relocate!(current_location)
    if profile    
      profile.set('location', 'current', current_location) 
      profile.save
    end
  end
  
  def reset_messages_count
    return if messages_count == 0
    
    self.messages_count = 0
    self.save
  end
  
  def befriend!(character)
    cid = character._id.to_s
    unless character_friend_ids.include?(cid)
      self.character_friend_ids << cid 
      save
    end
  end
  
  def skill_progress(skill)
    val = profile.get('experience', skill).count
    return 0 if val == 0
    
    val = val.to_f / (profile.get('skills', skill).count.to_f + 1)
    (val * 100).round(0)
  end
  
  private 
  
  def populate_profile
    self.profile = Profile.create(:character => self)
  end
end