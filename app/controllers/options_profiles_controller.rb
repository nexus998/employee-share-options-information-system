class OptionsProfilesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action -> {check_role(:admin)}
  before_action :set_options_profile, only: %i[ show edit update destroy ]

  # GET /options_profiles or /options_profiles.json
  def index
    @options_profiles = OptionsProfile.all
  end

  # GET /options_profiles/1 or /options_profiles/1.json
  def show
  end

  # GET /options_profiles/new
  def new
    @options_profile = OptionsProfile.new
  end

  # GET /options_profiles/1/edit
  def edit
  end

  # POST /options_profiles or /options_profiles.json
  def create
    @options_profile = OptionsProfile.new(options_profile_params)

    respond_to do |format|
      if @options_profile.save
        format.html { redirect_to options_profile_url(@options_profile), notice: t('notices.create') }
        format.json { render :show, status: :created, location: @options_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @options_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /options_profiles/1 or /options_profiles/1.json
  def update
    respond_to do |format|
      if @options_profile.update(options_profile_params)
        format.html { redirect_to options_profile_url(@options_profile), notice: t('notices.update') }
        format.json { render :show, status: :ok, location: @options_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @options_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options_profiles/1 or /options_profiles/1.json
  def destroy
    @options_profile.destroy

    respond_to do |format|
      format.html { redirect_to options_profiles_url, notice: t('notices.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_options_profile
      @options_profile = OptionsProfile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def options_profile_params
      params.require(:options_profile).permit(:label, :monetary_value)
    end
end
