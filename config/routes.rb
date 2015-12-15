Rails.application.routes.draw do

  # devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }
  devise_for :users, :skip => [ :sessions ], :controllers => { registrations: 'geoauth_registrations', omniauth_callbacks: 'omniauth_callbacks' }

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  get '/:service/sso_logout', to: "sso#logout"
  get '/:service/delete_cookie', to: "sso#delete_cookie"

  as :user do
    get '/login' => 'devise/geoauth_sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    match '/logout' => 'devise/geoauth_sessions#destroy', :as => :destroy_user_session,
          :via => Devise.mappings[:user].sign_out_via
    match '/geonetwork/logout' => 'devise/geoauth_sessions#destroy_cookie', params: { path: 'geonetwork'}, via: :get
  end

  #authenticated :user do
  #  root :to => 'home#index'
  #end
  root :to => "home#root"

  match "/autologin" => "auth#root", via: [ :get, :post ]
  get "/debug/check" => "home#check"

  get "/check_auth/authenticated", to: 'check_auth#authenticated'
  get "/check_auth/not_authenticated", to: 'check_auth#not_authenticated'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users
    resources :groups
    resources :roles
  end

  devise_scope :user do
    authenticated :user do
      match "/geoserver/j_spring_security_logout" => "devise/sessions#destroy", via: [ :get, :post ]
      get 'logout', :to => 'devise/sessions#destroy'
    end
  end

  match "*path" => "home#root", via: [ :get, :post, :put ]
end
