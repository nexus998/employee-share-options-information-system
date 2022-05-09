require "application_system_test_case"

class OptionsCalculationsTest < ApplicationSystemTestCase
  setup do
    @options_calculation = options_calculations(:one)
  end

  test "visiting the index" do
    visit options_calculations_url
    assert_selector "h1", text: "Options calculations"
  end

  test "should create options calculation" do
    visit options_calculations_url
    click_on "New options calculation"

    fill_in "Cliff", with: @options_calculation.cliff
    fill_in "Employee", with: @options_calculation.employee_id
    fill_in "Grant date", with: @options_calculation.grant_date
    fill_in "Grant type", with: @options_calculation.grant_type_id
    fill_in "Share number", with: @options_calculation.share_number
    fill_in "Tranches", with: @options_calculation.tranches
    fill_in "Vesting start date", with: @options_calculation.vesting_start_date
    click_on "Create Options calculation"

    assert_text "Options calculation was successfully created"
    click_on "Back"
  end

  test "should update Options calculation" do
    visit options_calculation_url(@options_calculation)
    click_on "Edit this options calculation", match: :first

    fill_in "Cliff", with: @options_calculation.cliff
    fill_in "Employee", with: @options_calculation.employee_id
    fill_in "Grant date", with: @options_calculation.grant_date
    fill_in "Grant type", with: @options_calculation.grant_type_id
    fill_in "Share number", with: @options_calculation.share_number
    fill_in "Tranches", with: @options_calculation.tranches
    fill_in "Vesting start date", with: @options_calculation.vesting_start_date
    click_on "Update Options calculation"

    assert_text "Options calculation was successfully updated"
    click_on "Back"
  end

  test "should destroy Options calculation" do
    visit options_calculation_url(@options_calculation)
    click_on "Destroy this options calculation", match: :first

    assert_text "Options calculation was successfully destroyed"
  end
end
