class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?(:step1) && @user.save
      log_in @user # 新規登録後ﾛｸﾞｲﾝする sessions_helperで定義済
      flash[:success] = "新規作成に成功しました。"
      redirect_to user_url(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.valid?(:step2) && @user.update(user_params)
      flash[:success] = "職員情報を更新しました。"
      redirect_to user_url(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:employee_number, :name, :base_pay, :email, :password, :password_confirmation)
    end
end
