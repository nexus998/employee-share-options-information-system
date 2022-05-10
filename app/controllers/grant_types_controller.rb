class GrantTypesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}
  before_action :set_grant_type, only: %i[ show edit update destroy ]

  # GET /grant_types or /grant_types.json
  def index
    @grant_types = GrantType.all
  end

  # GET /grant_types/1 or /grant_types/1.json
  def show
  end

  # GET /grant_types/new
  def new
    @grant_type = GrantType.new
  end

  # GET /grant_types/1/edit
  def edit
  end

  # POST /grant_types or /grant_types.json
  def create
    @grant_type = GrantType.new(grant_type_params)

    respond_to do |format|
      if @grant_type.save
        format.html { redirect_to grant_type_url(@grant_type), notice: t('notices.create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grant_types/1 or /grant_types/1.json
  def update
    respond_to do |format|
      if @grant_type.update(grant_type_params)
        format.html { redirect_to grant_type_url(@grant_type), notice: t('notices.update') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grant_types/1 or /grant_types/1.json
  def destroy
    @grant_type.destroy

    respond_to do |format|
      format.html { redirect_to grant_types_url, notice: t('notices.destroy') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant_type
      @grant_type = GrantType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grant_type_params
      params.require(:grant_type).permit(:name, :description, :cliff_percentage)
    end
end
