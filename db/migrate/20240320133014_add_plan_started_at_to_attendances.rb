class AddPlanStartedAtToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :plan_started_at, :datetime
    add_column :attendances, :plan_finished_at, :datetime
    add_column :attendances, :work_content, :string
    add_column :attendances, :confirmed_request, :string
    add_column :attendances, :approved, :boolean, default: false
    add_column :attendances, :work_type, :string
    add_column :attendances, :communication_work_type, :string
    add_column :attendances, :day_of_week, :string
    add_column :attendances, :overwork_status, :string
  end
end
