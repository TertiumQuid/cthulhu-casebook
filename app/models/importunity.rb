class Importunity
  include MongoMapper::Document
  
  key :pending_user_ids, Array
  key :rejected_user_ids, Array  
  
  belongs_to :user
  
  def self.request(sender, user_id)
    importunity = first_or_new(:user_id => user_id)
    
    if importunity.pending_user_ids.include?(sender._id)
      importunity.errors.add(:pending_user_ids, "Friendship has already been requested of that person")
    elsif importunity.rejected_user_ids.include?(sender._id)
      importunity.errors.add(:rejected_user_ids, "Your friendship has already been rejected by that person")
    elsif !(user = User.find(user_id))
      importunity.errors.add(:user_id, "Could not find that person")
    elsif sender.facebook_friend_ids.include?( user.facebook_id )
      importunity.errors.add(:user_id, "You have already befriended that person")
    else
      importunity.pending_user_ids << sender._id
      importunity.message_user(sender, user) if importunity.save 
    end
    importunity
  end
  
  def accept!(user_id)
    if pid = pending_user_ids.delete(user_id.to_s)
      if pending = User.find(pid)
        user.befriend!(pending)
        save
      end
    end
  end
  
  def reject!(user_id)
    if pid = pending_user_ids.delete(user_id.to_s)
      rejected_user_ids << pid
      save
    end
  end  
  
  def message_user(sender, recipient)
    msg = <<-msg
       <p>An individual by the name of <a href="/characters/#{sender.current_character._id}">#{sender.current_character.name}</a> seeks your friendship and talent in service of the greater good. Let them know your answer:</p>
       <p><a href="/importunity/#{sender._id}/accept">You agree they could be useful to you</a></p>
       <p><a href="/importunity/#{sender._id}/reject">You find them dangerous and untrue</a></p>
    msg
        
    Message.create :sender => sender.current_character.name,
                   :title => 'Your friendship is sought by a stranger',
                   :text => msg,
                   :character => recipient.current_character
  end

  def message_rejected_user(user_id)
    msg = <<-msg
       <p>It's rather presumptuous, no? <a href="/characters/#{user.current_character._id}">#{user.current_character.name}</a> would prefer that you keep your distance.</p>
    msg

    Message.create :sender => user.current_character.name,
                   :title => "Your friendship won't be necessary",
                   :text => msg,
                   :character => User.find(user_id).current_character
  end
  
  def message_accepted_user(user_id)
    msg = <<-msg
       <p>There's much that you and <a href="/characters/#{user.current_character._id}">#{user.current_character.name}</a> can do for each another; for instance, you never know when you'll need a fourth seat at bridge, or a sixth candle-bearer for a hexagram ritual.</p>
    msg

    Message.create :sender => user.current_character.name,
                   :title => "Your friendship is not without advantage",
                   :text => msg,
                   :character => User.find(user_id).current_character

  end
end