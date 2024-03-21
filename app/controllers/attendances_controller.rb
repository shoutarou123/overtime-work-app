class AttendancesController < ApplicationController
  

  def edit_overtime_req  # 残業申請画面
    
  end

  def update_overtime_req # 残業申請送信先
    if
    
    else
      flash[:danger] = "未入力項目があったため、申請をキャンセルしました。"
    end
    redirect_to attendances_edit_overtime_req_users_url
  end
end
