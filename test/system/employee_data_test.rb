require "application_system_test_case"

class EmployeeDataTest < ApplicationSystemTestCase
  setup do
    @employee_datum = employee_data(:one)
  end

  test "visiting the index" do
    visit employee_data_url
    assert_selector "h1", text: "Employee data"
  end

  test "should create employee datum" do
    visit employee_data_url
    click_on "New employee datum"

    fill_in "Employee", with: @employee_datum.employee_id
    fill_in "Field", with: @employee_datum.field_id
    fill_in "Value", with: @employee_datum.value
    click_on "Create Employee datum"

    assert_text "Employee datum was successfully created"
    click_on "Back"
  end

  test "should update Employee datum" do
    visit employee_datum_url(@employee_datum)
    click_on "Edit this employee datum", match: :first

    fill_in "Employee", with: @employee_datum.employee_id
    fill_in "Field", with: @employee_datum.field_id
    fill_in "Value", with: @employee_datum.value
    click_on "Update Employee datum"

    assert_text "Employee datum was successfully updated"
    click_on "Back"
  end

  test "should destroy Employee datum" do
    visit employee_datum_url(@employee_datum)
    click_on "Destroy this employee datum", match: :first

    assert_text "Employee datum was successfully destroyed"
  end
end
