class GrantRulesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}
  before_action :set_grant_rule, only: %i[ show edit update destroy ]

  # GET /grant_rules or /grant_rules.json
  def index
    @grant_rules = GrantRule.all
  end

  # GET /grant_rules/1 or /grant_rules/1.json
  def show
    @grant_type_names = GrantType.pluck(:name, :id)
  end

  # GET /grant_rules/new
  def new
    @grant_type_names = GrantType.pluck(:name, :id)
    @field_names = Field.pluck(:name)
    @grant_rule = GrantRule.new
  end

  # GET /grant_rules/1/edit
  def edit
    @grant_type_names = GrantType.pluck(:name, :id)
    @field_names = Field.pluck(:name)
  end

  def include_custom_params(grant_rule)
    puts params
    if params["Vesting start type"] == "Offset from grant date"
      grant_rule[:vesting_start]= 'offset_from_grant_date(' + params['Vesting start offset value'] + ')'
    elsif params["Vesting start type"] == "Custom"
      grant_rule[:vesting_start] = 'formula - ' + params["Vesting start custom value"]
    else
      grant_rule[:vesting_start] = params["grant_rule"]["vesting_start"]
    end

    if params["Cliff type"] == "Custom"
      grant_rule[:cliff] = 'formula - ' + params["Cliff custom value"]
    else
      grant_rule[:cliff] = params["grant_rule"]["cliff"]
    end


    if params["Tranches type"] == "Until the nth anniversary"
      grant_rule[:tranches] = 'until_the_nth_anniversary(' + params['Until the nth anniversary value'] + ')'
    elsif params["Tranches type"] == "Custom"
      grant_rule[:tranches] = 'formula - ' + params["Tranches custom value"]
    else
      grant_rule[:tranches] = params["grant_rule"]["tranches"]
    end

    if params["Share number type"] == "Custom"
      grant_rule[:share_number] = 'formula - ' + params["Share number custom value"].to_s
    else
      grant_rule[:share_number] = params["grant_rule"]["share_number"]
    end

    grant_rule[:trigger] = params["Trigger"] + (params["Trigger"] == "When field value has changed" ? (' - ' + params['Field']) : '')
  end

  # POST /grant_rules or /grant_rules.json
  def create
    puts '-----------------------------------------------------'
    puts grant_rule_params
    @grant_rule = GrantRule.new(grant_rule_params)

    include_custom_params(@grant_rule)

    respond_to do |format|
      if @grant_rule.save
        format.html { redirect_to grant_rule_url(@grant_rule), notice: t('notices.create') }
        format.json { render :show, status: :created, location: @grant_rule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grant_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grant_rules/1 or /grant_rules/1.json
  def update
    puts @grant_rule.cliff

    attributes = grant_rule_params.clone
    include_custom_params(attributes)

    respond_to do |format|

      if @grant_rule.update(attributes)
        format.html { redirect_to grant_rule_url(@grant_rule), notice: t('notices.update') }
        format.json { render :show, status: :ok, location: @grant_rule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grant_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grant_rules/1 or /grant_rules/1.json
  def destroy
    @grant_rule.destroy

    respond_to do |format|
      format.html { redirect_to grant_rules_url, notice: t('notices.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant_rule
      @grant_rule = GrantRule.find(params[:id])
      #include_custom_params(@grant_rule)
    end

    # Only allow a list of trusted parameters through.
    def grant_rule_params
      params.require(:grant_rule).permit(:grant_type_id, :vesting_start, :cliff, :tranches, :share_number)
    end
end
