class AddPlanStartedAtToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :plan_started_at, :datetime # 時間外勤務開始予定時間
    add_column :attendances, :plan_finished_at, :datetime # 時間外勤務終了予定時間
    add_column :attendances, :work_content, :string # 勤務内容
    add_column :attendances, :confirmed_request, :string # 申請先の名前
    add_column :attendances, :approved, :boolean, default: false
    add_column :attendances, :work_type, :string # 当非週
    add_column :attendances, :communication_work_type, :string # 通信時間
    add_column :attendances, :day_of_week, :string # 曜日
    add_column :attendances, :overwork_status, :string # 申請中かどうか
    add_column :attendances, :overtime_instructor, :string # 時間外勤務データ保存場所と思われる
    add_column :attendances, :planner, :string # 起案者
    add_column :attendances, :work_status, :string # 当,非,週,日,年,夏,特
    add_column :attendances, :overwork_chk, :boolean, default: false
    add_column :attendances, :send_approval, :string # 承認送信先の名前
  end
end
