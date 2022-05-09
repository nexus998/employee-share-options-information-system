require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    User.assign_role(@user)
    User.assign_employee_id(@user)
    sign_in @user
    @user.add_role(:admin)
    @participant = participants(:one)

  end

  test "should get index" do
    get participants_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_url
    assert_response :success
  end

  # test "should create participant" do
  #   puts Role.all.pluck(:name)
  #   assert_difference("Participant.count") do
  #     post participants_url, params: { participant: { email: @participant.email, employee_id: @participant.employee_id, role: @participant.role } }
  #   end

  #   assert_redirected_to participant_url(@participant)
  # end

  test "should show participant" do
    get participant_url(@participant)
    assert_response :success
  end

  test "should get edit" do
    get edit_participant_url(@participant)
    assert_response :success
  end

  test "should update participant" do
    patch participant_url(@participant), params: { participant: { email: @participant.email, employee_id: @participant.employee_id, role: @participant.role } }
    assert_redirected_to participant_url(@participant)
  end

  test "should destroy participant" do
    assert_difference("Participant.count", -1) do
      delete participant_url(@participant)
    end

    assert_redirected_to participants_url
  end

  test "should bulk upload" do
    post bulk_upload_participants_url, params: { file: fixture_file_upload("participant_bulk_upload.csv", "text/csv") }
    assert_redirected_to participants_url
  end
end
