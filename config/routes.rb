Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ﾛｸﾞｲﾝ機能
  get    '/login', to: 'sessions#new' # login画面
  post   '/login', to: 'sessions#create' # loginﾃﾞｰﾀ送信
  delete '/logout', to: 'sessions#destroy' # logout



  resources :users do
    collection do
      get 'attendances/edit_overtime_req' #残業申請
      patch 'attendances/update_overtime_req' #残業申請先
    end
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
  end
end