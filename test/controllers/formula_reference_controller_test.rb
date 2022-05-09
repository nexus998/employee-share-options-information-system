require "test_helper"

class FormulaReferenceControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @user.add_role(:admin)
  end
  test "should show index" do
    get docs_formula_reference_url
    assert_response :success
  end
end
