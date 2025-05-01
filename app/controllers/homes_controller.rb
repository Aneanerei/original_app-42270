class HomesController < ApplicationController
  def index
    year_param = params[:year]
    month_param = params[:month]
  
    year = year_param.present? ? year_param.to_i : Date.today.year
    month = month_param.present? ? month_param.to_i : Date.today.month
  
    @date = Date.new(year, month, 1)
  end
end
