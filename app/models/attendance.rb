class Attendance < ApplicationRecord
  belongs_to :user
  
  enum work_type: { 当: '当', 非: '非', 週: '週', 日: '日'}
  enum communication_work_type: { "22～24": '22～24', "0～2": '0～2', "2～4": '2～4', "4～6": '4～6'}

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

    # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end
