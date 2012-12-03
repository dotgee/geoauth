Geoauth::Application.routes.draw do
  resources :groups

  resources :roles

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }

  #authenticated :user do
  #  root :to => 'home#index'
  #end
  root :to => "home#root"

  match "/autologin" => "auth#root"

  namespace :admin do
    resources :users
  end

  devise_scope :user do
    authenticated :user do
      match "/geoserver/j_spring_security_logout" => "devise/sessions#destroy"
      get 'logout', :to => 'devise/sessions#destroy'
    end
  end

  mount_sextant if Rails.env.development?

  match "*path" => "home#root"
end
