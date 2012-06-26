CthulhuCasebook::Application.routes.draw do
  resource  :character, :only => [:edit, :new, :create], :controller => 'characters', :path_names => { :edit => 'profile' }
  resources :characters, :only => [:show]
  resources :equipment, :only => [] do
    resources :trappings, :only => [:update, :destroy]
  end
  
  resource  :location,  :only => [:show], :controller => 'locations' do
    resources :passage, :only => [:update], :controller => 'passages'
  end
  resources :messages, :only => [:index, :show]
  resources :locations, :only => [:index]
  resource  :monster, :only => [:new], :controller => 'monsters', :path_names => { :new => 'strategy' }
  resources :monster, :only => [:show], :controller => 'monsters'
  
  resources :encounters, :only => [:show] do
    resources :paths, :only => [:show]
  end
  resources :friends, :only => [:index]
  resources :importunity, :only => [:create], :controller => 'importunities' do
    member do
      get 'accept'
      get 'reject'
    end
  end
  
  resource :application,  :only => [:show]  
  root :to => 'application#show'
end