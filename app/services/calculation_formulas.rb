class CalculationFormulas
  attr_accessor :cliff

  def initialize(employee_id, grant_date, hire_date, cliff, emp_data, historical_emp_data)
    @employee_id = employee_id
    @grant_date = grant_date
    @hire_date = hire_date
    @cliff = cliff
    @emp_data = emp_data
    @historical_data = historical_emp_data
    # @all_emp_data = EmployeeDatum.with_no_assigned_calculations
  end

  def relevant_strike_price
    Valuation.all.order(:effective_date, :desc).last.strike_price
  end

  def relevant_market_price
    Valuation.all.order(:effective_date, :desc).last.market_price
  end

  def all_values_match?(employee_id, values)
    split = values.split(',')
    split.each do |s|
      id = s.split('-')[0]
      puts employee_id, s
      value = EmployeeDatum.find_by(employee_id: employee_id, field_id: id).value
      return false if value != s.split('-')[1]
    end
    true
  end

  def profile_share_amount
    mapping_values = OptionsProfileMap.pluck(:values)
    mapping_values.each do |m|
      next unless all_values_match?(@employee_id, m)

      found = OptionsProfileMap.find_by(values: m)
      if found.present?
        return found.options_profile.monetary_value
        break
      end
    end
  end

  def offset_from_grant_date(offset_value)
    @grant_date.to_date + offset_value.months
  end

  def until_the_nth_anniversary(n)
    nth_anniversary = @hire_date.to_date + n.years
    (nth_anniversary.year * 12 + nth_anniversary.month) - (@grant_date.to_date.year * 12 + @grant_date.to_date.month) - @cliff.to_i
  end

  def get_field(field_name)
    field = Field.find_by(name: field_name)
    # value = EmployeeDatum.find_by(employee_id: employee_id, field_id: field.id).value
    # value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where(options_calculations: nil).last
    value = @emp_data.where(employee_id: @employee_id, field_id: field.id).last.value
    # if !value.present?
    #   value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where(options_calculations.verified: false).last
    # end
    if field.field_type == 'Date'
      value.to_date
    elsif field.field_type == 'Number'
      value.to_i
    else
      value.to_s
    end
  rescue Exception => e
    puts 'Error raised while trying to get current value.'
    puts 'error is:', e
    0
  end

  def get_previous_field(field_name)
    field = Field.find_by(name: field_name)
    #  value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where.not(options_calculations: nil).last
    value = @historical_data.where(employee_id: @employee_id, field_id: field.id).last
    if value.present?
      value.value
    else
      0
    end
  end

  def evaluate_custom_formula(formula, formula_service)
    calculator = Keisan::Calculator.new
    calculator.evaluate(formula,
                        'offset_from_grant_date': proc { |offset_value|
                                                    formula_service.offset_from_grant_date(offset_value)
                                                  },
                        'field': proc { |field_name| formula_service.get_field(field_name) },
                        'profile_share_amount': proc { formula_service.profile_share_amount },
                        'until_the_nth_anniversary': proc { |n|
                                                       formula_service.until_the_nth_anniversary(n)
                                                     },
                        'previous_field': proc { |field_name|
                                            formula_service.get_previous_field(field_name)
                                          },
                        'relevant_strike_price': proc { formula_service.relevant_strike_price },
                        'relevant_market_price': proc { formula_service.relevant_market_price })
  end
end
