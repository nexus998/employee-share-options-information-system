class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action -> {check_role(:user)}
  layout 'participant'
  # respond_to 'docx'

  include OptionsCalculationsHelper

  def index
    @calculations = OptionsCalculation.where(employee_id: current_user.employee_id)

    # find the relevant market price for given grants


    vested_amounts = Array.new
    share_numbers = Array.new
    dates = Array.new
    vested_values = Array.new
    all_values = Array.new
    # valuations = Valuation.all
    @calculations.each do |calculation|
      amount = 0
      vest_start = calculation.vesting_start_date
      date_after_cliff = vest_start + calculation.cliff.months
      vest_end = calculation.vesting_end_date
      share_numbers.push(calculation.share_number)

      # find the relevant market price for given grants
      relevant_valuation = Valuation.last
      all_values.push((relevant_valuation.market_price.present? ? relevant_valuation.market_price : 0)  * calculation.share_number)
      now = Date.today + 24.months
      if now < date_after_cliff
        vested_amounts.push(0)
        dates.push(date_after_cliff)
        vested_values.push(0)
      elsif now >= date_after_cliff && now <= vest_end
          # add cliff because it has already passed
          amount += calculation.share_number * (calculation.grant_type.cliff_percentage/100)

          remaining_percent = 100 - calculation.grant_type.cliff_percentage
          remaining_share_options = calculation.share_number * (remaining_percent/100)
          shares_per_month = (remaining_share_options / calculation.tranches).round
          # get the difference between Date.now and date_after_cliff
          months_vested = ((now - date_after_cliff).to_f / 365 * 12).round
          dates.push(vest_start + calculation.cliff.months + months_vested.months)
          vested_amounts.push(amount + months_vested*shares_per_month)
          vested_values.push((amount + months_vested*shares_per_month) * (relevant_valuation.market_price.present? ? relevant_valuation.market_price : 0))
      else
        vested_amounts.push(calculation.share_number)
        vested_values.push(calculation.share_number * (relevant_valuation.market_price.present? ? relevant_valuation.market_price : 0))

      end
    end

    if @calculations.size > 0
      @vested_amount = vested_amounts.inject(:+)
      @unvested_amount = share_numbers.inject(:+) - @vested_amount
      @earliest_vest_date = dates.min
      @vested_value = vested_values.inject(:+)
      @unvested_value = all_values.inject(:+)
    end

  end

  def documents
    @options_calculations = OptionsCalculation.where(verified: true, employee_id: current_user.employee_id)
    @options_calculations_size = OptionsCalculation.where(verified: true, employee_id: current_user.employee_id).size

  end


  def calculated_options
    @options_calculations = OptionsCalculation.where(verified: true, employee_id: current_user.employee_id)
    col_names = OptionsCalculation.column_names
    @column_names_edited = Array.new
    col_names.each do |c|
      @column_names_edited.append(c.gsub('_', ' ').titleize)
    end
    @column_names_edited = @column_names_edited[2..]
    @column_names_edited = @column_names_edited.filter { |c| c != 'Created At' && c != 'Updated At' && c != 'Verified'}

    @column_names = Array.new
    col_names.each do |c|
      @column_names.push(c.dup)
    end
    @column_names = @column_names[2..]
    @column_names = @column_names.filter { |c| c != 'created_at' && c != 'updated_at' && c != 'verified'}
    @column_names[@column_names.index('grant_type_id')].sub!('grant_type_id', 'grant_type')
  end

  def generate_docx
    @selected_calc = OptionsCalculation.where(employee_id: current_user.employee_id, id: params[:id]).first
    @last_valuation = Valuation.all.order(:effective_date, :desc).first
    if !@selected_calc.present?
      redirect_to participant_documents_path, alert: 'You do not have access to this document.'
      return
    end
    respond_to do |format|
      if @selected_calc.present?
        format.docx { render docx: '/templates/options_certificate', filename: 'Options Certificate - ' + @selected_calc.grant_date.to_s + '.docx' }
      end
    end
  end

end
