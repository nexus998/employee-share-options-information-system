require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
  end
  test "should get home" do
    get dashboard_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end
end
