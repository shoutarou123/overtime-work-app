class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password]) # authenticate ﾊﾟｽﾜｰﾄﾞ認証失敗時falseを返す
      log_in(user) # sessions_helperのﾒｿｯﾄﾞ
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # sessions_helperのﾒｿｯﾄﾞ
      redirect_back_or(user) # sessions_helper参照
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in? # sessions_helperで定義済
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
