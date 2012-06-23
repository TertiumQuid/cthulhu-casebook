CthulhuCasebook::Application.routes.draw do
  resource  :character, :only => [:edit, :new, :create], :controller => 'characters', :path_names => { :edit => 'profile' }
  resource  :location,  :only => [:show], :controller => 'locations' do
    resources :passage, :only => [:update], :controller => 'passages'
  end
  resources :messages, :only => [:index, :show]
  resources :locations, :only => [:index]
  resource  :monster, :only => [:show], :controller => 'monsters'
  resources :monster, :only => [:delete]
  resources :encounters, :only => [:show] do
    resources :paths, :only => [:show]
  end
  
  resource :application,  :only => [:show]  
  root :to => 'application#show'  
end