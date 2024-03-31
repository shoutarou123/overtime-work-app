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
end
