require "test_helper"

class ValuationsControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
    @valuation = valuations(:one)
  end

  test "should get index" do
    get valuations_url
    assert_response :success
  end

  test "should get new" do
    get new_valuation_url
    assert_response :success
  end

  test "should create valuation" do
    assert_difference("Valuation.count") do
      post valuations_url, params: { valuation: { description: @valuation.description, effective_date: @valuation.effective_date, market_price: @valuation.market_price, strike_price: @valuation.strike_price } }
    end

    assert_redirected_to valuation_url(Valuation.last)
  end

  test "should show valuation" do
    get valuation_url(@valuation)
    assert_response :success
  end

  test "should get edit" do
    get edit_valuation_url(@valuation)
    assert_response :success
  end

  test "should update valuation" do
    patch valuation_url(@valuation), params: { valuation: { description: @valuation.description, effective_date: @valuation.effective_date, market_price: @valuation.market_price, strike_price: @valuation.strike_price } }
    assert_redirected_to valuation_url(@valuation)
  end

  test "should destroy valuation" do
    assert_difference("Valuation.count", -1) do
      delete valuation_url(@valuation)
    end

    assert_redirected_to valuations_url
  end
end
