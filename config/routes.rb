Myapp::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users,
             controllers: {omniauth_callbacks: "omniauth_callbacks",
                           registrations: "registrations"}
  resources :users, :only => [:show, :index]
end
