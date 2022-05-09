require "test_helper"

class OptionsCalculationsControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @options_calculation = options_calculations(:one)
  end

  test "should get index" do
    get options_calculations_url
    assert_response :success
  end

  test "should get ledger" do
    get '/lt/options_calculations/ledger'
    assert_response :success
  end

  test "should get new" do
    get new_options_calculation_url
    assert_response :success
  end

  test "should remove all previous calculations" do
    get '/lt/options_calculations/remove_all'
    assert_redirected_to new_options_calculation_url
  end

  test "should download certificates zip file" do
    puts OptionsCalculation.where(verified: false).size
    get '/lt/options_calculations/download_certificates'
    assert_response :success
  end

  test "should calculate options" do
    post '/lt/options_calculations/calculate', params: { grant_date: '2022-05-07' }
    assert_response :success
  end

  test "should verify calculations" do
    get '/lt/options_calculations/verify_calculations'
    assert_redirected_to ledger_options_calculations_path
  end



  test "should create options_calculation" do
    assert_difference("OptionsCalculation.count") do
      post options_calculations_url, params: { options_calculation: { cliff: @options_calculation.cliff, employee_id: @options_calculation.employee_id, grant_date: @options_calculation.grant_date, grant_type_id: @options_calculation.grant_type_id, share_number: @options_calculation.share_number, tranches: @options_calculation.tranches, vesting_start_date: @options_calculation.vesting_start_date } }
    end

    assert_redirected_to options_calculation_url(OptionsCalculation.last)
  end

  test "should show options_calculation" do
    get options_calculation_url(@options_calculation)
    assert_response :success
  end

  test "should get edit" do
    get edit_options_calculation_url(@options_calculation)
    assert_response :success
  end

  test "should update options_calculation" do
    patch options_calculation_url(@options_calculation), params: { options_calculation: { cliff: @options_calculation.cliff, employee_id: @options_calculation.employee_id, grant_date: @options_calculation.grant_date, grant_type_id: @options_calculation.grant_type_id, share_number: @options_calculation.share_number, tranches: @options_calculation.tranches, vesting_start_date: @options_calculation.vesting_start_date } }
    assert_redirected_to options_calculation_url(@options_calculation)
  end

  test "should destroy options_calculation" do
    assert_difference("OptionsCalculation.count", -1) do
      delete options_calculation_url(@options_calculation)
    end

    assert_redirected_to options_calculations_url
  end
end
