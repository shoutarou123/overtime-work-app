module SessionsHelper

  def log_in(user) # 引数に渡されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄでﾛｸﾞｲﾝする sessions_controller createのuser情報
    session[:user_id] = user.id
  end

  def remember(user) # 永続的セッションを記憶します（Userモデルを参照）
    user.remember
    cookies.permanent.signed[:user_id] = user.id # 永続cookieに永続化、暗号化したuser.idを代入
    cookies.permanent[:remember_token] = user.remember_token # 期限20年の永続cookieに代入 remember_tokenはuser.rb参照
  end

  # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out # セッションと@current_userを破棄します
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil # これもないとcurrent_userﾒｿｯﾄﾞにより@current_userに代入されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄは削除されない
  end
  
  def current_user # 現在ログイン中のユーザーがいる場合オブジェクトを返します。それ以外の場合はcookiesに対応するユーザーを返します。
    if (user_id = session[:user_id]) # 一時的ｾｯｼｮﾝにuser.idがtureの時
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

   # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil? # 一時的ｾｯｼｮﾝにuser.idが存在しないじゃないの時true
  end
end
