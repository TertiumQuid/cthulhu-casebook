module ActiveModel
  module RequirementSupport
    extend ActiveSupport::Concern
    
    included do
      many :requirements  
    end
    
    def displayable_requirement_taggings
      ['traits','pathology','belongings']
    end

    def requirement_display(show_all=false)
      display = show_all ? requirements : requirements.select { |r| displayable_requirement_taggings.include?(r.tagging) }
      display = display.map {|r| r.text }
      display = display.join(', ')
    end
    
    def available_for?(character)
      requirements.size == 0 || requirements.select{ |r| r.met_by? character.profile }.size > 0
    end
  end
end
