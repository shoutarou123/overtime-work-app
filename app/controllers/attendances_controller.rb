class AttendancesController < ApplicationController
  

  def edit_overtime_req  # 残業申請画面
    @user = User.find(params[:id])
  end

  def update_overtime_req # 残業申請送信先
    
  end
end
