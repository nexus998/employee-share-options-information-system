class OptionsCalculationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> { check_role(:admin) }
  before_action :set_options_calculation, only: %i[show edit update destroy]

  require 'htmltoword'
  require 'zip'

  def ledger
    @options_calculations = OptionsCalculation.verified
    @column_names = OptionsCalculation.get_relevant_column_names
    @column_names_edited = OptionsCalculation.get_pretty_column_names
  end

  # GET /options_calculations or /options_calculations.json
  def index
    @options_calculations = OptionsCalculation.unverified
    @column_names = OptionsCalculation.get_relevant_column_names
    @column_names_edited = OptionsCalculation.get_pretty_column_names
    @last_calculated_option = OptionsCalculation.last
  end

  def remove_all
    OptionsCalculation.unverified.destroy_all
    flash[:notice] = t('notices.remove_calcs')
    redirect_to new_options_calculation_path
  end

  def verify_calculations
    # set verified to true
    relevant_calcs = OptionsCalculation.unverified
    am = OptionsCalculation.unverified.size
    relevant_calcs.update_all(verified: true)
    redirect_to ledger_options_calculations_path, notice: t('notices.verified_calcs', amount: am)
    # create historical calculations
  end

  def download_certificates
    # this method needs to remain in the controller because it uses render.
    zip_name = 'certificates.zip'
    temp_file = Tempfile.new(zip_name)
    relevant_calcs = OptionsCalculation.unverified
    last_valuation = Valuation.all.order(:effective_date, :desc).last

    begin
      Zip::OutputStream.open(temp_file) { |zos| }

      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        relevant_calcs.each do |calc|
          template_string = render_to_string(template: 'user_dashboard/templates/options_certificate',
                                             layout: false, locals: { :@selected_calc => calc, :@last_valuation => last_valuation })
          puts template_string.class
          temp_docx = Tempfile.create(['OC', '.docx'], encoding: 'ascii-8bit')
          puts temp_docx.path
          cert_file = Htmltoword::Document.create(template_string,
                                                  (calc.employee_id.to_s + ' - ' + calc.id.to_s + ' - ' + calc.grant_date.to_s))

          temp_docx.write(cert_file)

          puts temp_docx.read
          zipfile.add(calc.employee_id.to_s + ' - ' + calc.id.to_s + ' - ' + calc.grant_date.to_s + '.docx',
                      temp_docx.path)

          temp_docx.close
        end
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
    # 1. Get employee data
    @employee_data = EmployeeDatum.with_no_assigned_calculations
    @emp_ids = @employee_data.map { |e| e.employee_id }.uniq
    calculator = OptionsCalculator.new(@emp_ids, params[:grant_date])
    calculator.calculate
    redirect_to options_calculations_path, notice: t('shared.options_calculated')
  end

  # GET /options_calculations/1 or /options_calculations/1.json
  def show; end

  # GET /options_calculations/new
  def new
    # @num_of_ids = EmployeeDatum.all.filter { |e| !e.options_calculations.present? }.pluck(:employee_id).uniq.count
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
    params.require(:options_calculation).permit(:employee_id, :grant_date, :vesting_start_date, :cliff, :tranches,
                                                :grant_type_id, :share_number)
  end
end
