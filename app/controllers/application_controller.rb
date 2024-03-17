class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # SessionsHelperをapplicationで呼びどこでも使えるようにしている

  $days_of_the_week = %w{日 月 火 水 木 金 土}
end
