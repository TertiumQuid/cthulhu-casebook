module ActiveModel
  module TaggableSupport
    extend ActiveSupport::Concern
    
    def tag
      _id.to_s.split('.').last if _id
    end

    def tagging
      _id.to_s.split('.').first if _id
    end    
    
    def apply_to(character)
      character.profile.set(tagging, tag, value) if respond_to?(:value)
    end    
  end    
end