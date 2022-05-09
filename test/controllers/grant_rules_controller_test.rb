require "test_helper"

class GrantRulesControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @grant_rule = grant_rules(:one)
  end

  test "should get index" do
    get grant_rules_url
    assert_response :success
  end

  test "should get new" do
    get new_grant_rule_url
    assert_response :success
  end

  test "should create grant_rule" do
    assert_difference("GrantRule.count") do
      post grant_rules_url, params: {
        "Vesting start type": "Offset from grant date",
        "Cliff type": "Custom",
        "Tranches type": "Until the nth anniversary",
        "Share number type": "Custom",
        "Trigger": "Always",
        'Vesting start offset value': "1",
        'Until the nth anniversary value': "1",
        grant_rule: { cliff: @grant_rule.cliff, grant_type_id: @grant_rule.grant_type_id, tranches: @grant_rule.tranches, vesting_start: @grant_rule.vesting_start, share_number: @grant_rule.share_number, trigger: @grant_rule.trigger }
      }
    end

    assert_redirected_to grant_rule_url(GrantRule.last)
  end

  test "should show grant_rule" do
    get grant_rule_url(@grant_rule)
    assert_response :success
  end

  test "should get edit" do
    get edit_grant_rule_url(@grant_rule)
    assert_response :success
  end

  test "should update grant_rule" do
    patch grant_rule_url(@grant_rule), params: {
       "Vesting start type": "Offset from grant date",
        "Cliff type": "Custom",
        "Tranches type": "Until the nth anniversary",
        "Share number type": "Custom",
        "Trigger": "Always",
        'Vesting start offset value': "1",
        'Until the nth anniversary value': "1",
        grant_rule: { cliff: @grant_rule.cliff, grant_type_id: @grant_rule.grant_type_id, tranches: @grant_rule.tranches, vesting_start: @grant_rule.vesting_start, share_number: @grant_rule.share_number, trigger: @grant_rule.trigger }
      }
    assert_redirected_to grant_rule_url(@grant_rule)
  end

  test "should destroy grant_rule" do
    assert_difference("GrantRule.count", -1) do
      delete grant_rule_url(@grant_rule)
    end

    assert_redirected_to grant_rules_url
  end
end
