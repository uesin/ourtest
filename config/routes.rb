Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: 'users/registrations' ,
    #これでoauthのコントローラが使えるようになります。
    omniauth_callbacks: 'users/omniauth_callbacks'
    }
  root to: 'posts#index'
  resources :posts
  resources :users, only: :show
end 

