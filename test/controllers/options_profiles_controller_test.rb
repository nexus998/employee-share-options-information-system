require "test_helper"

class OptionsProfilesControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @options_profile = options_profiles(:one)
  end

  test "should get index" do
    get options_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_options_profile_url
    assert_response :success
  end

  test "should create options_profile" do
    assert_difference("OptionsProfile.count") do
      post options_profiles_url, params: { options_profile: { label: @options_profile.label, monetary_value: @options_profile.monetary_value } }
    end

    assert_redirected_to options_profile_url(OptionsProfile.last)
  end

  test "should show options_profile" do
    get options_profile_url(@options_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_options_profile_url(@options_profile)
    assert_response :success
  end

  test "should update options_profile" do
    patch options_profile_url(@options_profile), params: { options_profile: { label: @options_profile.label, monetary_value: @options_profile.monetary_value } }
    assert_redirected_to options_profile_url(@options_profile)
  end

  test "should destroy options_profile" do
    assert_difference("OptionsProfile.count", -1) do
      delete options_profile_url(@options_profile)
    end

    assert_redirected_to options_profiles_url
  end
end
