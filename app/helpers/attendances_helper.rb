module AttendancesHelper
  def calculate_day_of_week(date)
    Date.parse(date.to_s).strftime("%u")
  end
end
