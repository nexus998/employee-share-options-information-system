require "application_system_test_case"

class OptionsProfilesTest < ApplicationSystemTestCase
  setup do
    @options_profile = options_profiles(:one)
  end

  test "visiting the index" do
    visit options_profiles_url
    assert_selector "h1", text: "Options profiles"
  end

  test "should create options profile" do
    visit options_profiles_url
    click_on "New options profile"

    fill_in "Label", with: @options_profile.label
    fill_in "Monetary value", with: @options_profile.monetary_value
    click_on "Create Options profile"

    assert_text "Options profile was successfully created"
    click_on "Back"
  end

  test "should update Options profile" do
    visit options_profile_url(@options_profile)
    click_on "Edit this options profile", match: :first

    fill_in "Label", with: @options_profile.label
    fill_in "Monetary value", with: @options_profile.monetary_value
    click_on "Update Options profile"

    assert_text "Options profile was successfully updated"
    click_on "Back"
  end

  test "should destroy Options profile" do
    visit options_profile_url(@options_profile)
    click_on "Destroy this options profile", match: :first

    assert_text "Options profile was successfully destroyed"
  end
end
