Geoauth::Application.routes.draw do

  # devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }
  devise_for :users, :skip => [ :sessions ]
  as :user do
    get '/login' => 'devise/geoauth_sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    match '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session,
          :via => Devise.mappings[:user].sign_out_via
  end

  #authenticated :user do
  #  root :to => 'home#index'
  #end
  root :to => "home#root"

  match "/autologin" => "auth#root"
  match "/debug/check" => "home#check"

  namespace :admin do
    resources :users
    resources :groups
    resources :roles
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
