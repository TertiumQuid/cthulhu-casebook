CthulhuCasebook::Application.routes.draw do
  resource  :character, :only => [:edit, :new, :create], :controller => 'characters', :path_names => { :edit => 'profile' }
  resources :characters, :only => [:show] do
    resource :conferences, :only => [:show]
    resources :gifts, :only => [:new, :update]
  end
  resources :gifts, :only => [] do
    member do
      get 'accept'
      get 'reject'
    end    
  end
  resources :equipment, :only => [] do
    resources :trappings, :only => [:update, :destroy]
  end
  
  resource  :location,  :only => [:show], :controller => 'locations' do
    resources :passage, :only => [:update], :controller => 'passages'
  end
  resources :messages, :only => [:index, :show]
  resources :locations, :only => [:index] do
    resource  :monster, :only => [:new], :controller => 'monsters', :path_names => { :new => 'strategy' }
    resources :monster, :only => [:show], :controller => 'monsters'    
  end
  resource  :monster, :only => [:new], :controller => 'monsters', :path_names => { :new => 'strategy' }
  resources :monster, :only => [:show], :controller => 'monsters'
  
  resources :encounters, :only => [:show] do
    resources :paths, :only => [:show]
  end
  resources :demises, :only => [:show]
  resources :friends, :only => [:index]
  resources :importunity, :only => [:create], :controller => 'importunities' do
    member do
      get 'accept'
      get 'reject'
    end
  end

  resources :help, :only => [:show], :controller => 'help'
  resource :application,  :only => [:show]
  resource :facebook, :only => [], :controller => 'facebook' do
    member do
      get :channel
    end
  end
  root :to => 'application#show'
end