class RenameStuff < ActiveRecord::Migration[7.0]
  def change
    rename_column :employee_data_options_calculations, :option_calculation_id, :options_calculation_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
