  module ApplicationHelper
    def human_amount_in_man_yen(amount)
      if amount >= 100_000_000
        "#{(amount / 100_000_000.0).round(1)}億円"
      elsif amount >= 10_000
        "#{(amount / 10_000.0).round(1)}万円"
      elsif amount >= 1_000
        "#{(amount / 1_000.0).round(1)}千円"
      else
        "#{amount}円"
      end
    end
  end
  
