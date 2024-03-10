class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password]) # authenticate ﾊﾟｽﾜｰﾄﾞ認証失敗時falseを返す
    
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end
end
