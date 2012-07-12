module ActiveModel
  module ContestableSupport
    extend ActiveSupport::Concern
    
    DIFFICULTY_FACTOR = 7
    
    def chance_of_success(contest_tag=nil, contest_difficulty=nil)
      contest_difficulty ||= difficulty
      base = 50 - (contest_difficulty * DIFFICULTY_FACTOR)
      base = base + contest_tag.value.to_i unless contest_tag.blank? || !contest_tag.send(:numeric?)
      base
    end

    def check_success(chance, max_range=100, forced_at=3)
      chance = [chance, forced_at].max
      chance = [chance, max_range-forced_at].min
      Rails.logger.info "CHANCE=#{chance}"
      rand(max_range) <= chance
    end
    
    def difficulty_text
      case difficulty
      when nil
        nil
      when 1
        'Simple'
      when 2
        'Very easy'      
      when 3
        'Easy'
      when 4, 5
        'Moderate'
      when 6
        'Difficult'
      when 7,8
        'Very difficult'
      else
        'Impossible'
      end
    end    
  end    
end