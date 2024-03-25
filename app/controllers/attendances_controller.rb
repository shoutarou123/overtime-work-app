class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def edit_overtime_req  # 残業申請画面
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @superior = User.where(superior: true)
    @office_staff = User.where(office_staff: true)
  end

  def update_overtime_req # 残業申請送信先
    overtime_req_params.each do |id, item|
      attendance = Attendance.find(id)
      if item["plan_started_at(4i)"].blank? || item["plan_started_at(5i)"].blank? || item["plan_finished_at(4i)"].blank? || item["plan_finished_at(5i)"].blank? || item[:work_content].blank? && item[:confirmed_request].blank?
        flag = 1
      else
        flag = 1
      end
      if flag == 1
        attendance.overwork_status = "申請中"
        overtime_instructor = item["overtime_instructor"]
        attendance.update(item.merge(overtime_instructor: overtime_instructor))
        flash[:success] = "時間外勤務申請を送信しました。"
      else
        flash[:danger] = "未入力な項目があったため、申請をキャンセルしました。"
      end
    end
    redirect_to users_url
  end

  def edit_overtime_aprv
    @user = User.find(params[:id])
    @attendances = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中")

      respond_to do |format|
        format.html { render partial: 'attendances/edit_overtime_aprv', locals: { attendance: @attendance } }
        format.turbo_stream
      end
  end

end

private

  def attendances_params
    params.require(:user).permit(attendances: [:work_content])[:attendances]
  end

  def overtime_req_params
    params.require(:user).permit(attendances: [:planner, :worked_on, :day_of_week, :work_type, :communication_work_type, :plan_started_at, :plan_finished_at, :work_content, :confirmed_request]
  )[:attendances]
  end