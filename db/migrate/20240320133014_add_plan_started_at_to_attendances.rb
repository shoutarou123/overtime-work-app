class AddPlanStartedAtToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :plan_started_at, :datetime
    add_column :attendances, :plan_finished_at, :datetime
    add_column :attendances, :work_content, :string
  end
end
