Geoauth::Application.routes.draw do
  devise_for :users

  #authenticated :user do
  #  root :to => 'home#index'
  #end
  root :to => "home#root"

  match "/login" => "auth#root"

  devise_scope :user do
    authenticated :user do
      match "/geoserver/j_spring_security_logout" => "devise/sessions#destroy"
    end
  end

  match "*path" => "home#root"
end
