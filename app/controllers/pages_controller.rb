class PagesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}

  def home
    calcs = OptionsCalculation.where(verified: true)
    if calcs.present?
      @calculated_options_grouped = calcs.group(:grant_date).sum(:share_number)
      @average_shares_given = calcs.average(:share_number)
      @last_calc = calcs.order(grant_date: :desc).first.grant_date
      @shares_per_type = calcs.group(:grant_type).sum(:share_number)
    else
      # :nocov:
      @calculated_options_grouped = []
      @average_shares_given = 0
      @last_calc = Date.today
      @shares_per_type = []
      # :nocov:
    end


    emp_data = EmployeeDatum.all.pluck(:employee_id)
    if emp_data.present?
      @num_of_ids = EmployeeDatum.all.pluck(:employee_id).uniq.size
    else
      # :nocov:
      @num_of_ids = 0
      # :nocov:
    end

    @unverified_calcs = OptionsCalculation.where(verified: false).count

    @market_prices = Valuation.all.pluck(:effective_date, :market_price)


  end
end
