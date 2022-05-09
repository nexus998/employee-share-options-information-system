class ChangeColumnNameInEmployeeDataOptionsCalculations < ActiveRecord::Migration[7.0]
  def change
    rename_column :employee_data_options_calculations, :employee_data_id, :employee_datum_id
    rename_column :employee_data_options_calculations, :options_calculations_id, :option_calculation_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
