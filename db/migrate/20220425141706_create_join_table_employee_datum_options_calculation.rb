class CreateJoinTableEmployeeDatumOptionsCalculation < ActiveRecord::Migration[7.0]
  def change
    create_join_table :EmployeeData, :OptionsCalculations do |t|
      #t.index [:employee_datum_id, :options_calculation_id], name: 'idx_employee_data_options_calculations'
       #t.index [:options_calculation_id, :employee_datum_id]
    end
  end
end
