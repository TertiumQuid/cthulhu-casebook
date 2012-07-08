class Session
  include MongoMapper::Document
  
  LENGTH = 3
    
  class << self
    def expired_at
      LENGTH.hours.ago.utc
    end
  
    def expired
      Session.where(:created_at.lt => expired_at)
    end
  
    def sweep
      Session.delete_all(:created_at.lt => expired_at)
    end
  end
end