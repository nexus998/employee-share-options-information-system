class RemoveOptionsCalculationFromEmployeeData < ActiveRecord::Migration[7.0]
  def change
    remove_column :employee_data, :options_calculation_id

    drop_table :historical_calculations
    drop_table :test_models
  end
end
