class ParticipantsController < ApplicationController
  layout 'admin'
  before_action :set_participant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action -> { check_role(:admin) }
  respond_to :html

  def index
    @participants = Participant.all
    @role_names = Role.all.pluck(:name, :id)
    respond_with(@participants)
  end

  def show
    respond_with(@participant)
  end

  def new
    @participant = Participant.new
    @role_names = Role.all.pluck(:name, :id)
    respond_with(@participant, @role_names)

  end

  def edit
    @role_names = Role.all.pluck(:name, :id)
  end

  def bulk_upload
    Participant.import(params[:file])
    redirect_to participants_path, notice: t('notices.imported')
  end

  def create
    @participant = Participant.new(participant_params)
    @participant.save
    respond_with(@participant)
  end

  def update
    @participant.update(participant_params)
    respond_with(@participant)
  end

  def destroy
    @participant.destroy
    respond_with(@participant)
  end

  private
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def participant_params
      params.require(:participant).permit(:email, :employee_id, :role_id)
    end
end
