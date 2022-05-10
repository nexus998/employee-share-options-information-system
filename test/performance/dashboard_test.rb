require 'test_helper'
require 'rails/performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class DashboardTest < ActionDispatch::PerformanceTest
    require Devise::Test::IntegrationHelpers
    setup do
        @user = users(:one)
        login(@user)
        @user.add_role(:admin)
    end

    def test_homepage
        get '/'
    end
end