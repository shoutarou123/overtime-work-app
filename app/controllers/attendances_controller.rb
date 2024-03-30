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
    @attendance = @user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true)
    @office_staff = User.where(office_staff: true)

    respond_to do |format|
      format.html { render partial: 'attendances/edit_overtime_req', locals: { attendance: @attendance } }
      format.turbo_stream
    end
  end

  def update_overtime_req # 残業申請送信先
    @user = User.find(params[:id])
    overtime_req_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:planner].blank? || item[:worked_on].blank? || item[:work_type].blank? || item[:communication_work_type].blank? || item[:plan_started_at].blank? || item[:plan_finished_at].blank? || item[:work_content].blank? && item[:confirmed_request].blank?
        flag = 1 if item[:approved] == '1'
      else
        flag = 1
      end
      if flag == 1
        attendance.overwork_chk = '0'
        attendance.overwork_status = "申請中"
        overtime_instructor = item["overtime_instructor"]
        attendance.update(item.merge(overtime_instructor: overtime_instructor))
        flash[:success] = "時間外勤務申請を送信しました。"
      else
        flash[:danger] = "未入力な項目があったため、申請をキャンセルしました。"
      end
    end
    redirect_to user_url
  end

  def edit_overtime_aprv
    @user = User.find(params[:id])
    @attendances = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中")
    @users = User.where(id: @attendances.select(:user_id))
  end

  def update_overtime_aprv
    @user = User.find(params[:id])
      flag = 0
      overtime_aprv_params.each do |id, item|
        if item[:overwork_chk] == '1'
          unless item[:overwork_status] == "否認"
            flag += 1
            attendance = Attendance.find(id)
            if item[:overwork_status] == "否認"
              attendance.work_content = nil
            end
            attendance.update(item)
          end
        end
      end
      if flag > 0
        flash[:success] = "時間外勤務申請を更新しました。"
      else
        flash[:danger] = "時間外勤務申請の更新に失敗しました。"
      end
      redirect_to user_url(date: params[:date])
  end

end

private

  def attendances_params
    params.require(:user).permit(attendances: [:work_status])[:attendances]
  end

  def overtime_req_params
    params.require(:user).permit(attendances: [:planner, :worked_on, :work_type, :communication_work_type, :plan_started_at, :plan_finished_at, :work_content, :confirmed_request])[:attendances]
  end

  def overtime_aprv_params
    params.require(:user).permit(attendances: [:overwork_status, :overwork_chk])[:attendances]
  end