class AttendancesController < ApplicationController


  def edit_overtime_req  # 残業申請画面
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @superior = User.where(superior: true)
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
    @users = User.where(id: @attendances.select(:user_id))
    
      respond_to do |format|
        format.html { render partial: 'attendances/edit_overtime_aprv', locals: { attendance: @attendance } }
        format.turbo_stream
      end
  end

end

private
  def overtime_req_params
    params.require(:user).permit(attendances: [:day_of_week, :work_type, :communication_work_type, :plan_started_at, :plan_finished_at, :work_content, :confirmed_request])[:attendances]
  end