module SessionsHelper

  def log_in(user) # 引数に渡されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄでﾛｸﾞｲﾝする sessions_controller createのuser情報
    session[:user_id] = user.id
  end

  def log_out # セッションと@current_userを破棄します
    session.delete(:user_id)
    @current_user = nil # これもないとcurrent_userﾒｿｯﾄﾞにより@current_userに代入されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄは削除されない
  end
  
  def current_user # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
    if session[:user_id] # 一時的ｾｯｼｮﾝにuser.idがtureの時
      @current_user ||= User.find_by(id: session[:user_id])

      #if @current_user.nil? # 現在ﾕｰｻﾞｰ情報が存在しない時
        #@current_user = User.find_by(id: session[:user_id]) # ﾃﾞｰﾀﾍﾞｰｽからidｶﾗﾑの一時的ｾｯｼｮﾝにあるuser.idを取得
      #else
        #@current_user # 現在ﾕｰｻﾞｰ情報があればそれを使用する
    end
  end

  def logged_in?
    !current_user.nil? # 一時的ｾｯｼｮﾝにuser.idが存在しないじゃないの時true
  end
end
