CthulhuCasebook::Application.routes.draw do
  resource  :character, :only => [:edit, :new, :create], :controller => 'characters', :path_names => { :edit => 'profile' }
  resource  :location,  :only => [:show], :controller => 'locations'
  resources :locations, :only => [:index]
  resources :encounters, :only => [:show] do
    resources :paths, :only => [:show]
  end
  
  resource :application,  :only => [:show]  
  root :to => 'application#show'  
end