class RenameEmployeeDataOptionsCalculations < ActiveRecord::Migration[7.0]
  def change
    rename_table "EmployeeData_OptionsCalculations", "employee_data_options_calculations"
  end
end
