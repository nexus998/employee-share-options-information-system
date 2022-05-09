require "application_system_test_case"

class GrantTypesTest < ApplicationSystemTestCase
  setup do
    @grant_type = grant_types(:one)
  end

  test "visiting the index" do
    visit grant_types_url
    assert_selector "h1", text: "Grant types"
  end

  test "should create grant type" do
    visit grant_types_url
    click_on "New grant type"

    fill_in "Description", with: @grant_type.description
    fill_in "Name", with: @grant_type.name
    click_on "Create Grant type"

    assert_text "Grant type was successfully created"
    click_on "Back"
  end

  test "should update Grant type" do
    visit grant_type_url(@grant_type)
    click_on "Edit this grant type", match: :first

    fill_in "Description", with: @grant_type.description
    fill_in "Name", with: @grant_type.name
    click_on "Update Grant type"

    assert_text "Grant type was successfully updated"
    click_on "Back"
  end

  test "should destroy Grant type" do
    visit grant_type_url(@grant_type)
    click_on "Destroy this grant type", match: :first

    assert_text "Grant type was successfully destroyed"
  end
end
