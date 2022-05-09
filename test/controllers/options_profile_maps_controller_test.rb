require "test_helper"

class OptionsProfileMapsControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
end
  test "should show index" do
    get options_profile_mapping_new_url
    assert_response :success
  end

  test "should import" do
    post options_profile_mapping_import_url, params: { mapping_file: fixture_file_upload('mapping_test.csv', 'text/csv') }
    assert_redirected_to options_profiles_path
  end

  test "should remove all" do
    get options_profile_mapping_remove_all_url
    assert_redirected_to options_profile_mapping_new_url
  end
end
