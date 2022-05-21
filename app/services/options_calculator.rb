class OptionsCalculator
  def initialize(emp_ids, grant_date)
    @emp_ids = emp_ids
    @grant_date = grant_date
  end

  def get_grant_types_for_employee(_emp_id, _employee_data, historical_data, formula_service)
    types_to_calculate = []
    has_historical_data = historical_data.size > 0
    grant_rules = GrantRule.all
    grant_rules.each do |r|
      # check if trigger of each rule matches criteria
      if r.trigger == 'When employee has no historical data'
        types_to_calculate.push(r) unless has_historical_data
      elsif r.trigger == 'When employee has historical data'
        types_to_calculate.push(r) if has_historical_data
      elsif r.trigger == 'Always'
        types_to_calculate.push(r)
      elsif r.trigger.include?('When field value has changed')
        if has_historical_data
          trigger_value_name = r.trigger.split(' - ')[-1]
          last_value = formula_service.get_previous_field(trigger_value_name)
          curr_val = formula_service.get_field(trigger_value_name)
          puts last_value, curr_val
          types_to_calculate.push(r) if curr_val != last_value and has_historical_data
        end
      end
    end
    types_to_calculate
  end

  def evaluate_vesting_start_date(formula_service, vesting_start_value)
    vesting_start = Date.today
    # evaluate vesting_start_date
    if vesting_start_value.include?('offset_from_grant_date')
      arg = vesting_start_value.split('(')[1].split(')')[0]
      vesting_start = formula_service.offset_from_grant_date(arg.to_i).to_date
    elsif vesting_start_value.include? 'formula - '
      formula = vesting_start_value.split('formula - ')[-1]
      vesting_start = formula_service.evaluate_custom_formula(formula, formula_service).to_date
    else
      vesting_start = vesting_start_value.to_date
    end
    vesting_start
  end

  def evaluate_cliff(formula_service, cliff_value)
    cliff = 0
    if cliff_value.include? 'formula - '
      formula = cliff_value.split('formula - ')[-1]
      cliff = formula_service.evaluate_custom_formula(formula, formula_service).to_i
    else
      cliff = cliff_value.to_i
    end
    formula_service.cliff = cliff
    cliff
  end

  def evaluate_tranches(formula_service, tranches_value)
    tranches = 0
    if tranches_value.include? 'formula - '
      formula = tranches_value.split('formula - ')[-1]
      tranches = formula_service.evaluate_custom_formula(formula, formula_service).to_i
    elsif tranches_value.include? 'Until the nth anniversary'
      arg = tranches_value.split('(')[1].split(')')[0]
      tranches = formula_service.until_the_nth_anniversary(arg.to_i).to_i
    else
      tranches = tranches_value.to_i
    end
    tranches
  end

  def evaluate_vesting_end_date(vesting_start_value, cliff_value, tranches_value)
    vesting_start_value + cliff_value.months + tranches_value.months
  end

  def evaluate_share_number(formula_service, share_number_value)
    share_number = 0
    if share_number_value.include? 'formula - '
      formula = share_number_value.split('formula - ')[-1]
      share_number = formula_service.evaluate_custom_formula(formula, formula_service).to_i
    else
      share_number = share_number_value.to_i
    end
    share_number
  end

  def calculate
    @emp_ids.each do |e|
      employee_data = EmployeeDatum.with_no_assigned_calculations.where(employee_id: e)
      historical_data = EmployeeDatum.with_assigned_calculations.where(employee_id: e)
      hire_date = EmployeeDatum.hire_date(e)
      formula_service = CalculationFormulas.new(e, @grant_date, hire_date, 0, employee_data,
                                                historical_data)

      types_to_calculate = get_grant_types_for_employee(e, employee_data, historical_data, formula_service)
      employee_data_to_append_to = employee_data

      # now I have the grant types that should trigger
      types_to_calculate.each do |t|
        vesting_start = evaluate_vesting_start_date(formula_service, t.vesting_start)
        cliff = evaluate_cliff(formula_service, t.cliff)
        tranches = evaluate_tranches(formula_service, t.tranches)
        vesting_end = evaluate_vesting_end_date(vesting_start, cliff, tranches)
        share_number = evaluate_share_number(formula_service, t.share_number)
        # calculate the grant amount
        OptionsCalculation.create!(employee_id: e,
                                   grant_date: @grant_date,
                                   grant_type: t.grant_type,
                                   vesting_start_date: vesting_start,
                                   cliff: cliff,
                                   tranches: tranches,
                                   vesting_end_date: vesting_end,
                                   share_number: share_number,
                                   verified: false,
                                   employee_data: employee_data_to_append_to)
      end
    end
  end
end
