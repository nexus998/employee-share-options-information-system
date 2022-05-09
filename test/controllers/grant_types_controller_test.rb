require "test_helper"

class GrantTypesControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @grant_type = grant_types(:one)
  end

  test "should get index" do
    get grant_types_url
    assert_response :success
  end

  test "should get new" do
    get new_grant_type_url
    assert_response :success
  end

  test "should create grant_type" do
    assert_difference("GrantType.count") do
      post grant_types_url, params: { grant_type: { description: @grant_type.description, name: @grant_type.name } }
    end

    assert_redirected_to grant_type_url(GrantType.last)
  end

  test "should show grant_type" do
    get grant_type_url(@grant_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_grant_type_url(@grant_type)
    assert_response :success
  end

  test "should update grant_type" do
    patch grant_type_url(@grant_type), params: { grant_type: { description: @grant_type.description, name: @grant_type.name } }
    assert_redirected_to grant_type_url(@grant_type)
  end

  test "should destroy grant_type" do
    assert_difference("GrantType.count", -1) do
      delete grant_type_url(@grant_type)
    end

    assert_redirected_to grant_types_url
  end
end
