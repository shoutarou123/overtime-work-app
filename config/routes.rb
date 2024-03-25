Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ﾛｸﾞｲﾝ機能
  get    '/login', to: 'sessions#new' # login画面
  post   '/login', to: 'sessions#create' # loginﾃﾞｰﾀ送信
  delete '/logout', to: 'sessions#destroy' # logout



  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month' # 勤務編集画面
      patch 'attendances/update_one_month' # 勤務編集更新機能
      get 'attendances/edit_overtime_req' # 時間外勤務申請
      patch 'attendances/update_overtime_req' # 時間外勤務申請先
      get 'attendances/edit_overtime_aprv' # 所属長が時間外勤務申請確認する画面
    end
  end
end