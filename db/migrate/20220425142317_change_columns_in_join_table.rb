class ChangeColumnsInJoinTable < ActiveRecord::Migration[7.0]
  def change
    rename_column "EmployeeData_OptionsCalculations", "EmployeeDatum_id", "employee_datum_id"
    rename_column "EmployeeData_OptionsCalculations", "OptionsCalculation_id", "options_calculation_id"
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
