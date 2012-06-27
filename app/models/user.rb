class User
  include MongoMapper::Document
  
  key :email, String, :required => true, :unique => true
  key :gender, String
  key :facebook_id, String
  key :facebook_friend_ids, Array
  
  has_many :characters
  has_one  :importunity
  
  def befriend!(user)
    self.facebook_friend_ids ||= []
    unless user.blank? || facebook_friend_ids.include?(user.facebook_id)
      self.facebook_friend_ids << user.facebook_id
      save
      
      characters.each do |c1|
        user.characters.each do |c2|
          c1.befriend!(c2) && c2.befriend!(c1)
        end
      end
    end
  end
  
  def facebook_friends
    User.where(:facebook_friend_ids => facebook_id) if facebook_id
  end
  
  def current_character
    characters.sort(:_id).last
  end
end