class AddOptionsCalculationToEmployeeData < ActiveRecord::Migration[7.0]
  def change
    add_reference :employee_data, :options_calculation, null: true, foreign_key: true
  end
end
