class ValuationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}
  before_action :set_valuation, only: %i[ show edit update destroy ]

  # GET /valuations or /valuations.json
  def index
    @valuations = Valuation.all
  end

  # GET /valuations/1 or /valuations/1.json
  def show
  end

  # GET /valuations/new
  def new
    @valuation = Valuation.new
  end

  # GET /valuations/1/edit
  def edit
  end

  # POST /valuations or /valuations.json
  def create
    @valuation = Valuation.new(valuation_params)

    respond_to do |format|
      if @valuation.save
        format.html { redirect_to valuation_url(@valuation), notice: t('notices.create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valuations/1 or /valuations/1.json
  def update
    respond_to do |format|
      if @valuation.update(valuation_params)
        format.html { redirect_to valuation_url(@valuation), notice: t('notices.update') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valuations/1 or /valuations/1.json
  def destroy
    @valuation.destroy

    respond_to do |format|
      format.html { redirect_to valuations_url, notice: t('notices.destroy') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valuation
      @valuation = Valuation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def valuation_params
      params.require(:valuation).permit(:market_price, :strike_price, :effective_date, :description)
    end
end
