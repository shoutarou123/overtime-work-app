class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 新規登録後ﾛｸﾞｲﾝする sessions_helperで定義済
      flash[:success] = "新規作成に成功しました。"
      redirect_to user_url(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "職員情報を更新しました。"
      redirect_to user_url(@user)
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
  
    respond_to do |format|
      format.html { render partial: 'users/edit_basic_info', locals: { user: @user } }
      format.turbo_stream
    end
  end

  def update_basic_info
    if @user.update(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の基本情報の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end

    respond_to do |format|
      format.html { redirect_to users_url }
      format.turbo_stream
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :employee_number, :base_pay, :password, :password_confirmation, :base_pay, :department, :job_title)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :employee_number, :base_pay, :password, :password_confirmation, :base_pay, :department, :job_title)
    end
end
