require 'active_model/taggable_support'
require 'active_support/inflector'

class Gift
  include MongoMapper::Document
  include ActiveModel::TaggableSupport
  
  key :item, String
  belongs_to :sender, :class_name => 'Character'
  belongs_to :recipient, :class_name => 'Character'
  
  def tag; item && item.split('.').last; end
  def tagging; item && item.split('.').first; end  
  
  def self.give(sender, character_id, item_id)
    gift = Gift.new(:item => item_id, :sender => sender, :recipient_id => character_id)
    if item = sender.profile.get(gift.tagging, gift.tag)
      if gift.recipient.location.value == sender.location.value
        sender.profile.deduct!(gift.tagging, gift.tag)
        if gift.save
          gift.message_character 
        end
      else
        gift.errors.add(:recipient_id, "Cannot give from different locations")        
      end
    else
      gift.errors.add(:sender_id, "You do not have that item to give")
    end
    gift
  end
  
  def accept!
    recipient.profile.set(tagging, tag, 1) && recipient.profile.save
    destroy
  end
  
  def reject!
    destroy
  end  
  
  def message_character
    msg = <<-msg
       <p>Your valued friend <a href="/characters/#{sender._id}">#{sender.name}</a> offers you a gift to assist the ways and means of your investigations:</p>
       <blockquote><strong>#{tag.titleize}</strong></blockquote>
       <p><a href="/gifts/#{_id}/accept">You accept the item</a></p>
       <p><a href="/gifts/#{_id}/reject">You can't find a use for it, and politely decline</a></p>
    msg
        
    Message.create :sender => sender.name,
                   :title => 'Your friend offers a gift',
                   :text => msg,
                   :character => recipient
  end
end