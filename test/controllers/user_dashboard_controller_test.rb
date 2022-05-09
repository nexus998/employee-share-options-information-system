require "test_helper"

class UserDashboardControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    #assign_role(@user)
    @user.add_role(:user)
  end

  test "should get index" do
    puts participant_dashboard_url
    get participant_dashboard_url
    assert_response :success
  end

  test "should get documents" do
    get participant_documents_url
    assert_response :success
  end

  test "should get calculated options" do
    get participant_calculated_options_url
    assert_response :success
  end

  test "should get certificate" do
    #'/participant/documents/download'
    get participant_documents_download_url + "?id=#{OptionsCalculation.last.id}"
    assert_response :success
  end

  test "should not get certificate" do
    get participant_documents_download_url + "?id=#{OptionsCalculation.first.id}"
    assert_response :success
  end
end
