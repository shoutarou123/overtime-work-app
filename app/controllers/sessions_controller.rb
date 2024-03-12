class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password]) # authenticate ﾊﾟｽﾜｰﾄﾞ認証失敗時falseを返す
      log_in(user) # sessions_helperのﾒｿｯﾄﾞ
      remember(user) # sessions_helperのﾒｿｯﾄﾞ
      redirect_to user_url(user)
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out # sessions_helperで定義済
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
