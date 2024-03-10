class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # SessionsHelperをapplicationで呼びどこでも使えるようにしている
end
