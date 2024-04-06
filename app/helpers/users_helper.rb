module UsersHelper
  

  def unit_price_125(base_pay) # 単価125
    (base_pay*12/1875.5*125/100).round
  end

  def unit_price_135(base_pay) # 単価135(休日単価)
    (base_pay*12/1875.5*135/100).round
  end

  def unit_price_150(base_pay) # 単価150
    (base_pay*12/1875.5*150/100).round
  end

  def unit_price_160(base_pay) # 単価160
    (base_pay*12/1875.5*160/100).round
  end

  def unit_price_25(base_pay) # 夜間単価
    (base_pay*12/1875.5*25/100).round
  end

  def sum_h_125
    @attendances.sum(:unit_h_125)
  end

  def sum_m_125
    @attendances.sum(:unit_m_125)
  end

  def sum_125
    total_hours = sum_h_125 + sum_m_125 / 60
    total_hours += 1 if sum_m_125 % 60 >= 30
    total_hours
  end

  def sum_h_135
    @attendances.sum(:unit_h_135)
  end

  def sum_m_135
    @attendances.sum(:unit_m_135)
  end

  def sum_135
    total_hours = sum_h_135 + sum_m_135 / 60
    total_hours += 1 if sum_m_135 % 60 >= 30
    total_hours
  end

  def sum_h_150
    @attendances.sum(:unit_h_150)
  end

  def sum_m_150
    @attendances.sum(:unit_m_150)
  end

  def sum_150
    total_hours = sum_h_150 + sum_m_150 / 60
    total_hours += 1 if sum_m_150 % 60 >= 30
    total_hours
  end

  def sum_h_160
    @attendances.sum(:unit_h_160)
  end

  def sum_m_160
    @attendances.sum(:unit_m_160)
  end

  def sum_160
    total_hours = sum_h_160 + sum_m_160 / 60
    total_hours += 1 if sum_m_160 % 60 >= 30
    total_hours
  end
end
