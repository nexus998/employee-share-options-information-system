require "application_system_test_case"

class ValuationsTest < ApplicationSystemTestCase
  setup do
    @valuation = valuations(:one)
  end

  test "visiting the index" do
    visit valuations_url
    assert_selector "h1", text: "Valuations"
  end

  test "should create valuation" do
    visit valuations_url
    click_on "New valuation"

    fill_in "Description", with: @valuation.description
    fill_in "Effective date", with: @valuation.effective_date
    fill_in "Market price", with: @valuation.market_price
    fill_in "Strike price", with: @valuation.strike_price
    click_on "Create Valuation"

    assert_text "Valuation was successfully created"
    click_on "Back"
  end

  test "should update Valuation" do
    visit valuation_url(@valuation)
    click_on "Edit this valuation", match: :first

    fill_in "Description", with: @valuation.description
    fill_in "Effective date", with: @valuation.effective_date
    fill_in "Market price", with: @valuation.market_price
    fill_in "Strike price", with: @valuation.strike_price
    click_on "Update Valuation"

    assert_text "Valuation was successfully updated"
    click_on "Back"
  end

  test "should destroy Valuation" do
    visit valuation_url(@valuation)
    click_on "Destroy this valuation", match: :first

    assert_text "Valuation was successfully destroyed"
  end
end
