module ActionPack
  module UserSupport
    extend ActiveSupport::Concern
    
    included do
      helper_method :current_user, :current_user_id
    end    
    
    def current_user
      @current_user ||= User.find(current_user_id)
    end    
    
    def current_user_id
      session[:user_id]
    end
  end
end
