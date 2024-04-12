class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: []
  before_action :admin_user, only: [:new, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: :show

  def index
    @users = User.all
  end

  def show
    @aprv_count = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中").count # 時間外勤務申請のお知らせ件数
    @app_count = Attendance.where(send_approval: @user.name, overwork_status: "承認").count
    @rep_count = Attendance.where(report_to: @user.name, overwork_status: "報告中").count
    @attendance = @user.attendances.find_by(worked_on: @first_day)
    @superior = User.where(superior: true).where.not(id: @current_user.id)
    @attendance_count = Attendance.where(aprv_confirmed: @user.name, aprv_status: "申請中").count # 勤怠変更のお知らせ件数
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       # 新規登録後ﾛｸﾞｲﾝする sessions_helperで定義済
      flash[:success] = "新規作成に成功しました。"
      redirect_to users_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "職員情報を更新しました。"
      redirect_to users_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "#{@user.name}の基本情報の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :employee_number, :base_pay, :password, :password_confirmation, :department, :job_title)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :employee_number, :base_pay, :password, :password_confirmation, :department, :job_title)
    end
end
