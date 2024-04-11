class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :office_staff_user, only: [:edit_one_month, :update_one_month, :edit_overtime_req, :update_overtime_app]
  before_action :superior_user_and_report_user, only: [:edit_overtime_aprv, :overtime_report]

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update!(item)
      end
    end
    flash[:success] = "勤務情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def edit_overtime_req  # 時間外申請画面
    @user = User.find(params[:id])
    @attendance = @user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true)
    @office_staff = User.where(office_staff: true)
  end

  def update_overtime_req # 時間外申請送信
    @user = User.find(params[:id])
    overtime_req_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:planner].blank? || item[:work_type].blank? || item[:communication_work_type].blank? || item[:plan_started_at].blank? || item[:plan_finished_at].blank? || item[:work_content].blank? || item[:confirmed_request].blank?
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
        NoticeMailer.overtime_req_notice.deliver_now
      else
        flash[:danger] = "未入力な項目があったため、申請をキャンセルしました。"
      end
    end
    redirect_to user_url
  end

  def edit_overtime_aprv # 所属長が時間外申請内容を確認する画面
    @user = User.find(params[:id])
    @attendances = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中")
    @users = User.where(id: @attendances.select(:user_id))
    @office_staff = User.where(office_staff: true)
  end

  def update_overtime_aprv # 所属長が時間外申請内容を送信
    @user = User.find(params[:id])
      flag = 0
      overtime_aprv_params.each do |id, item|

        if item[:overwork_chk] == '1' && item[:send_approval].present?
          unless item[:overwork_status] == "申請中"
            flag += 1
            attendance = Attendance.find(id)
            if item[:overwork_status] == "否認"
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

  def update_overtime_app # 所属長から承認された内容の画面
    @user = User.find(params[:id])
    @attendances = Attendance.where(send_approval: @user.name, overwork_status: "承認")
    @users = User.where(id: @attendances.select(:user_id))
    @report = User.where(report: true)
  end

  def update_overtime_rep # 時間外報告送信
    @user = User.find(params[:id])
    flag = 0
    overtime_rep_params.each do |id, item|

      if item[:started_at].present? && item[:finished_at].present? && item[:report_to].present?
        flag += 1
        attendance = Attendance.find(id)
        attendance.overwork_chk = '0'
        attendance.overwork_status = "報告中"
        overtime_instructor = item["overtime_instructor"]
        attendance.update(item.merge(overtime_instructor: overtime_instructor))
      end
      if flag > 0
        flash[:success] = "時間外勤務報告を送信しました。"
        NoticeMailer.overtime_report_notice.deliver_now
      else
        flash[:danger] = "未入力な項目があったため、報告をキャンセルしました。"
      end
    end
    redirect_to user_url
  end

  def overtime_report # 時間外報告内容画面
    @user = User.find(params[:id])
    @attendances = Attendance.where(report_to: @user.name, overwork_status: "報告中")
    @users = User.where(id: @attendances.select(:user_id))
  end

  def update_overtime_report # 時間外報告内容確認後送信
    flag = 0
      update_overtime_report_params.each do |id, item|
        if item[:overwork_rep_chk] == '1'
          unless item[:overwork_status] == "報告中"
            flag += 1
            attendance = Attendance.find(id)
            if item[:overwork_status] == "却下"
              if attendance.started_at.present? &&  attendance.finished_at.present?
                attendance.started_at = nil
                attendance.finished_at = nil
                if attendance.unit_h_125.present?
                  attendance.unit_h_125 = nil
                elsif attendance.unit_m_125.present?
                  attendance.unit_m_125 = nil
                elsif attendance.unit_h_135.present?
                  attendance.unit_h_135 = nil
                elsif attendance.unit_m_135.present?
                  attendance.unit_m_135 = nil
                elsif attendance.unit_h_150.present?
                  attendance.unit_h_150 = nil
                elsif attendance.unit_m_150.present?
                  attendance.unit_m_150 = nil
                elsif attendance.unit_h_160.present?
                  attendance.unit_h_160 = nil
                elsif attendance.unit_m_160
                  attendance.unit_m_160 = nil
                end
              end
            end
            attendance.update(item)
          end
        end
      end
    if flag > 0
      flash[:success] = "時間外報告を送信しました。"
    else
      flash[:danger] = "時間外報告の更新に失敗しました。"
    end
    redirect_to user_url(date: params[:date])
  end

  def update_attendance_req # 勤務変更申請 patch
    flag = 0
    attendance_req_params.each do |id, item|
      if item[:aprv_confirmed].present?
        flag += 1
        attendance = Attendance.find(id)
        attendance.aprv_status = "申請中"
        attendance.update(item)
      end
      if flag > 0
        NoticeMailer.update_attendance_req.deliver_now
        flash[:success] = "勤務変更申請を送信しました。"
      else
        flash[:danger] = "勤務変更申請に送信に失敗しました。"
      end
      redirect_to user_url(date: params[:date])
    end
  end

  def edit_chg_req # 分署長が勤務変更内容確認
    @user = User.find(params[:id])
    @attendances = Attendance.where(aprv_confirmed: @user.name, aprv_status: "申請中")
    @users = User.where(id: @attendances.select(:user_id))
  end

  def update_attendance_aprv
    flag = 0
    attendance_aprv_params.each do |id, item|
      if item[:aprv_chk] == "1"
        unless[:aprv_status] == "申請中"
          flag += 1
          attendance = Attendance.find(id)
          if item[:aprv_status] == "否認"
            attendance.aprv_status = nil
            attendance.aprv_confirmed = nil
          end
          attendance.update(item)
        end
      end
    end
    if flag > 0
      flash[:success] = "勤務申請承認等について送信しました。"
    else
      flash[:danger] = "勤務申請承認等について送信に失敗しました。"
    end
    redirect_to user_url
  end
end

private

  def attendances_params
    params.require(:user).permit(attendances: [:work_status])[:attendances]
  end

  def overtime_req_params
    params.require(:user).permit(attendances: [:planner, :work_type, :communication_work_type, :plan_started_at, :plan_finished_at, :work_content, :confirmed_request])[:attendances]
  end

  def overtime_aprv_params
    params.require(:user).permit(attendances: [:overwork_status, :overwork_chk, :send_approval])[:attendances]
  end

  def overtime_rep_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :unit_h_125, :unit_m_125, :unit_h_135, :unit_m_135, :unit_h_150, :unit_m_150, :unit_h_160, :unit_m_160, :report_to])[:attendances]
  end

  def update_overtime_report_params
    params.require(:user).permit(attendances: [:overwork_status, :overwork_rep_chk])[:attendances]
  end

  def attendance_req_params
    params.require(:user).permit(attendances: :aprv_confirmed)[:attendances]
  end

  def attendance_aprv_params
    params.require(:user).permit(attendances: [:aprv_chk, :aprv_status])[:attendances]
  end