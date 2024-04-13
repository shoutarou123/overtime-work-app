class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # SessionsHelperをapplicationで呼びどこでも使えるようにしている

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。

  # beforフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in? # session_helper参照
      store_location # session_helper参照
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  def current_user?(user)
    user == current_user # =だと別のユーザーの情報見れてしまう
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def superior_user_and_report_user
    redirect_to root_url unless current_user.superior? && current_user.report?
  end

  def office_staff_user
    redirect_to root_url unless current_user.office_staff?
  end

  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

  def admin_or_correct_user # 管理権限者、または現在ﾛｸﾞｲﾝしているﾕｰｻﾞｰを許可します。
    @user = User.find(params[:user_id]) if @user.blank? # @userが空だったらuser_idを探して代入
    unless current_user?(@user) || current_user.admin? || current_user.office_staff || current_user.superior # 現在ﾕｰｻﾞｰじゃない又は管理権限が無い場合
      flash[:danger] = "権限がありません。"
      redirect_to(root_url)
    end
  end
end
