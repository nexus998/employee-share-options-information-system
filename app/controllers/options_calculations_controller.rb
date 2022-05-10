class OptionsCalculationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}
  before_action :set_options_calculation, only: %i[ show edit update destroy ]

  require 'htmltoword'
  require 'zip'

  def ledger
    @options_calculations = OptionsCalculation.where(verified: true)
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

  # GET /options_calculations or /options_calculations.json
  def index
    @options_calculations = OptionsCalculation.where(verified: false)
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
    @last_calculated_option = OptionsCalculation.last
  end

  def remove_all
    OptionsCalculation.where(verified: false).destroy_all
    flash[:notice] = t('notices.remove_calcs')
    redirect_to new_options_calculation_path
  end

  def offset_from_grant_date(offset_value, grant_date)
    grant_date.to_date + offset_value.months
  end

  def until_the_nth_anniversary(n, grant_date, hire_date, cliff)
    nth_anniversary = hire_date.to_date + n.years
    return (nth_anniversary.year*12 + nth_anniversary.month) - (grant_date.to_date.year*12 + grant_date.to_date.month) - cliff.to_i
  end

  def get_field(field_name, employee_id, employee_data)
    begin
      field = Field.find_by(name: field_name)
      # value = EmployeeDatum.find_by(employee_id: employee_id, field_id: field.id).value
      # value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where(options_calculations: nil).last
      value = employee_data.where(employee_id: employee_id, field_id: field.id).last.value
      # if !value.present?
      #   value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where(options_calculations.verified: false).last
      # end
      if field.field_type == 'Date'
        return value.to_date
      elsif field.field_type == 'Number'
        return value.to_i
      else
        return value.to_s
      end
    rescue Exception => e
      puts 'Error raised while trying to get current value.'
      puts 'error is:', e
      return 0
    end
  end

  def relevant_strike_price()
    return Valuation.all.order(:effective_date, :desc).last.strike_price
  end

  def relevant_market_price()
    return Valuation.all.order(:effective_date, :desc).last.market_price
  end

  def profile_share_amount(employee_id)
    mapping_values = OptionsProfileMap.pluck(:values)
    mapping_values.each do |m|
      if all_values_match?(employee_id, m)
        puts '-----------------'
        found = OptionsProfileMap.find_by(values: m)
        if found.present?
          return found.options_profile.monetary_value
          puts share_number
          break
        end
      end
    end
    return 0
  end

  def get_previous_field(field_name, employee_id, historical_data)
     field = Field.find_by(name: field_name)
    #  value = EmployeeDatum.left_joins(:options_calculations).where(employee_id: employee_id, field_id: field.id).where.not(options_calculations: nil).last
     value = historical_data.where(employee_id: employee_id, field_id: field.id).last
     if value.present?
        return value.value
     else
      return 0
     end
  end

  def evaluate_custom_formula(formula, employee_id, hire_date, grant_date, cliff, emp_data, historical_emp_data)
    calculator = Keisan::Calculator.new
    calculator.evaluate(formula,
    'offset_from_grant_date': Proc.new { |offset_value| offset_from_grant_date(offset_value, params[:grant_date]) },
    'field': Proc.new { |field_name| get_field(field_name, employee_id, emp_data) },
    'profile_share_amount': Proc.new { profile_share_amount(employee_id) },
    'until_the_nth_anniversary': Proc.new { |n, grant_date, hire_date, cliff| until_the_nth_anniversary(n, grant_date, hire_date, cliff) },\
    'previous_field': Proc.new { |field_name| get_previous_field(field_name, employee_id, historical_emp_data) },
    'relevant_strike_price': Proc.new { relevant_strike_price() },
    'relevant_market_price': Proc.new { relevant_market_price() },
  )
  end

  def all_values_match?(employee_id, values)
    split = values.split(',')
    split.each do |s|
      id = s.split('-')[0]
      puts employee_id, s
      value = EmployeeDatum.find_by(employee_id: employee_id, field_id: id).value
      if value != s.split('-')[1]
        return false
      end
    end
    return true
  end

  def verify_calculations
    # set verified to true
    relevant_calcs = OptionsCalculation.where(verified: false)
    am = OptionsCalculation.where(verified: false).size
    relevant_calcs.update_all(verified: true)
    redirect_to ledger_options_calculations_path, notice: t('notices.verified_calcs', amount: am)
    # create historical calculations

  end

  def download_certificates
    zip_name = 'certificates.zip'
    temp_file = Tempfile.new(zip_name)
    relevant_calcs = OptionsCalculation.where(verified: false)
    last_valuation = Valuation.all.order(:effective_date, :desc).last

    begin
      Zip::OutputStream.open(temp_file) { |zos| }

      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        relevant_calcs.each do |calc|
          template_string = render_to_string(:template => 'user_dashboard/templates/options_certificate', layout: false, :locals => { :@selected_calc => calc, :@last_valuation => last_valuation })
          puts template_string.class
          #temp_docx = Tempfile.new(['OC', '.docx'], encoding: 'ascii-8bit')
          temp_docx = Tempfile.create(['OC', '.docx'], encoding: 'ascii-8bit')
          puts temp_docx.path
          cert_file = Htmltoword::Document.create(template_string, (calc.employee_id.to_s + ' - ' + calc.id.to_s + ' - ' + calc.grant_date.to_s))

          temp_docx.write(cert_file)

          puts temp_docx.read
          zipfile.add(calc.employee_id.to_s + ' - ' + calc.id.to_s + ' - ' + calc.grant_date.to_s + '.docx', temp_docx.path)

          temp_docx.close
        end
        #puts 'REDIRECT TO OPTIONS CALCULATIONS', options_calculations_path
        #redirect_to options_calculations_path
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: zip_name)
    rescue Exception => e
      puts e
    ensure
      temp_file.close
      temp_file.unlink

    end
  end

  def calculate
    # OptionsCalculation.delete_all
    # 1. Get employee data
    #@employee_data = EmployeeDatum.all.filter { |e| !e.options_calculations.present? }
    @employee_data = EmployeeDatum.left_joins(:options_calculations).where(options_calculations: nil)
    @emp_ids = @employee_data.map { |e| e.employee_id }.uniq
    grant_rules = GrantRule.all
    @emp_ids.each do |e|
      employee_data = EmployeeDatum.left_joins(:options_calculations).where(employee_id: e).where(options_calculations: nil)
      historical_data = EmployeeDatum.left_joins(:options_calculations).where(employee_id: e).where.not(options_calculations: nil)
      hire_date = get_field('Hire date', e, employee_data)
      # for each employee ID in the employee data we need to create a calculation
      # to do that we firstly need to determine which grant types this employee needs.
      types_to_calculate = Array.new
      has_historical_data = historical_data.size > 0
      grant_rules.each do |r|
        # check if trigger of each rule matches criteria
        if r.trigger == 'When employee has no historical data'
          types_to_calculate.push(r) if !has_historical_data
        elsif r.trigger == 'When employee has historical data'
          types_to_calculate.push(r) if has_historical_data
        elsif r.trigger == 'Always'
          types_to_calculate.push(r)
        elsif r.trigger.include?('When field value has changed')
          if has_historical_data
            trigger_value_name = r.trigger.split(' - ')[-1]
            last_value = get_previous_field(trigger_value_name, e, historical_data)
            curr_val = get_field(trigger_value_name, e, employee_data)
            puts last_value, curr_val
            if curr_val != last_value and has_historical_data
              puts "CHECKED THAT FIELD VALUE HAS CHANGED."
              types_to_calculate.push(r)
            end
          end
        else
          # Now it's set to Never
        end
      end
      puts types_to_calculate
      # employee_data_to_append_to = EmployeeDatum.left_joins(:options_calculations).where(employee_id: e).where(options_calculations: nil)
      employee_data_to_append_to = employee_data
      puts employee_data_to_append_to.pluck(:value)
      # now I have the grant types that should trigger
      types_to_calculate.each do |t|
        puts t.grant_type.name
        vesting_start = Date.today
        # evaluate vesting_start_date
        if t.vesting_start.include?('offset_from_grant_date')
          arg = t.vesting_start.split('(')[1].split(')')[0]
          vesting_start = offset_from_grant_date(arg.to_i, params[:grant_date]).to_date
        elsif t.vesting_start.include? 'formula - '
          formula = t.vesting_start.split('formula - ')[-1]
          vesting_start = evaluate_custom_formula(formula, e, hire_date, params[:grant_date], 0, employee_data, historical_data).to_date
        else
          vesting_start = t.vesting_start.to_date
        end
        cliff = 0
        if t.cliff.include? 'formula - '
          formula = t.cliff.split('formula - ')[-1]
          cliff = evaluate_custom_formula(formula, e, hire_date, params[:grant_date], 0, employee_data, historical_data).to_i
        else
          cliff = t.cliff.to_i
        end
        tranches = 0
        if t.tranches.include? 'formula - '
          formula = t.tranches.split('formula - ')[-1]
          tranches = evaluate_custom_formula(formula, e, hire_date, params[:grant_date], cliff, employee_data, historical_data).to_i
        elsif t.tranches.include? 'Until the nth anniversary'
          arg = t.tranches.split('(')[1].split(')')[0]
          tranches = until_the_nth_anniversary(arg.to_i, params[:grant_date], hire_date, cliff).to_i
        else
          tranches = t.tranches.to_i
        end
        vesting_end = vesting_start + cliff.months + tranches.months
        # calculate the grant amount
        share_number = 0
        if t.share_number.include? 'formula - '
          formula = t.share_number.split('formula - ')[-1]
          share_number = evaluate_custom_formula(formula, e, hire_date, params[:grant_date], cliff, employee_data, historical_data).to_i
        else
          share_number = t.share_number.to_i
        end

        #employee_data_to_append_to = EmployeeDatum.where(employee_id: e).filter {|it| !it.options_calculations.present? }\
        #employee_data_to_append_to.each do |dat|
        OptionsCalculation.create!(employee_id: e,
        grant_date: params[:grant_date],
        grant_type: t.grant_type,
        vesting_start_date: vesting_start,
        cliff: cliff,
        tranches: tranches,
        vesting_end_date: vesting_end,
        share_number: share_number,
        verified: false,
        employee_data: employee_data_to_append_to)
        #end
      end
    end
    redirect_to options_calculations_path, notice: t('shared.options_calculated')
  end

  # GET /options_calculations/1 or /options_calculations/1.json
  def show
  end

  # GET /options_calculations/new
  def new
    #@num_of_ids = EmployeeDatum.all.filter { |e| !e.options_calculations.present? }.pluck(:employee_id).uniq.count
    @num_of_ids = EmployeeDatum.left_joins(:options_calculations).where(options_calculations: nil).pluck(:employee_id).uniq.count
  end

  # GET /options_calculations/1/edit
  def edit
    @grant_type_names = GrantType.pluck(:name, :id)
  end

  # POST /options_calculations or /options_calculations.json
  def create
    @options_calculation = OptionsCalculation.new(options_calculation_params)

    respond_to do |format|
      if @options_calculation.save
        format.html { redirect_to options_calculation_url(@options_calculation), notice: t('notices.create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /options_calculations/1 or /options_calculations/1.json
  def update
    respond_to do |format|
      if @options_calculation.update(options_calculation_params)
        format.html { redirect_to options_calculation_url(@options_calculation), notice: t('notices.update') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options_calculations/1 or /options_calculations/1.json
  def destroy
    @options_calculation.destroy

    respond_to do |format|
      format.html { redirect_to options_calculations_url, notice: t('notices.destroy') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_options_calculation
      @options_calculation = OptionsCalculation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def options_calculation_params
      params.require(:options_calculation).permit(:employee_id, :grant_date, :vesting_start_date, :cliff, :tranches, :grant_type_id, :share_number)
    end
end
