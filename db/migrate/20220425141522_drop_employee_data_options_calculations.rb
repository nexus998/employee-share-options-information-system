class DropEmployeeDataOptionsCalculations < ActiveRecord::Migration[7.0]
  def change
    drop_table :employee_data_options_calculations
  end
end
