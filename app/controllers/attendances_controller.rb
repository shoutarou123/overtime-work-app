class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_overtime_req

  def edit_overtime_req  #残業申請
    @attendance = @user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true).where.not(id: @current_user.id)
  end
end
