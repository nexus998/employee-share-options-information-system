require "test_helper"

class UserErrorControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:user)
  end
  test "should get index" do
    get user_error_index_url
    assert_response :success
  end
end
