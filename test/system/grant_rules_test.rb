require "application_system_test_case"

class GrantRulesTest < ApplicationSystemTestCase
  setup do
    @grant_rule = grant_rules(:one)
  end

  test "visiting the index" do
    visit grant_rules_url
    assert_selector "h1", text: "Grant rules"
  end

  test "should create grant rule" do
    visit grant_rules_url
    click_on "New grant rule"

    fill_in "Cliff", with: @grant_rule.cliff
    fill_in "Grant type", with: @grant_rule.grant_type_id
    fill_in "Tranches", with: @grant_rule.tranches
    fill_in "Vesting start", with: @grant_rule.vesting_start
    click_on "Create Grant rule"

    assert_text "Grant rule was successfully created"
    click_on "Back"
  end

  test "should update Grant rule" do
    visit grant_rule_url(@grant_rule)
    click_on "Edit this grant rule", match: :first

    fill_in "Cliff", with: @grant_rule.cliff
    fill_in "Grant type", with: @grant_rule.grant_type_id
    fill_in "Tranches", with: @grant_rule.tranches
    fill_in "Vesting start", with: @grant_rule.vesting_start
    click_on "Update Grant rule"

    assert_text "Grant rule was successfully updated"
    click_on "Back"
  end

  test "should destroy Grant rule" do
    visit grant_rule_url(@grant_rule)
    click_on "Destroy this grant rule", match: :first

    assert_text "Grant rule was successfully destroyed"
  end
end
