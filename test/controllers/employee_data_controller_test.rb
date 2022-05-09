require "test_helper"

class EmployeeDataControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    # OmniAuth.config.test_mode = true
    # Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    # Rails.application.env_config["omniauth.auth"]  = google_oauth2_mock
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @employee_datum = employee_data(:one)
  end

  teardown do
    OmniAuth.config.test_mode = false
  end

  test "should get index" do
    sign_in users(:one)
    get employee_data_url
    assert_response :success
  end

  test "should get new" do
    get (new_employee_datum_path + "?force=true")
    assert_response :success
  end

  test "should create employee_datum" do
    assert_difference("EmployeeDatum.count") do
      post employee_data_path, params: { employee_datum: { employee_id: @employee_datum.employee_id, field_id: @employee_datum.field_id, value: @employee_datum.value } }
    end

    assert_redirected_to employee_datum_url(EmployeeDatum.last)
  end

  test "should show employee_datum" do
    get employee_datum_url(@employee_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_datum_path(@employee_datum)
    assert_response :success
  end

  test "should update employee_datum" do
    patch employee_datum_url(@employee_datum), params: { employee_datum: { employee_id: @employee_datum.employee_id, field_id: @employee_datum.field_id, value: @employee_datum.value } }
    assert_redirected_to employee_datum_url(@employee_datum)
  end

  test "should destroy employee_datum" do
    assert_difference("EmployeeDatum.count", -1) do
      delete employee_datum_url(@employee_datum)
    end

    assert_redirected_to employee_data_url
  end

  test "should import" do
    post employee_data_import_url, params: { file: fixture_file_upload("bd_import_test_small.csv", "text/csv") }
    assert_redirected_to employee_data_path
  end
end
