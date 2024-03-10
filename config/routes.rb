Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ﾛｸﾞｲﾝ機能
  get    '/login', to: 'sessions#new' # login画面
  post   '/login', to: 'sessions#create' # loginﾃﾞｰﾀ送信
  delete '/logout', to: 'sessions#destroy' # logout

  resources :users
end