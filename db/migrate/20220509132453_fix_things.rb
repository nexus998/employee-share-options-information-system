class FixThings < ActiveRecord::Migration[7.0]
  def change
    change_column :employee_data, :field_id, :bigint
    change_column :employee_data_options_calculations, :employee_datum_id, :bigint
    change_column :employee_data_options_calculations, :options_calculation_id, :bigint
    change_column :grant_rules, :grant_type_id, :bigint
    change_column :options_calculations, :grant_type_id, :bigint
    change_column :options_profile_maps, :options_profile_id, :bigint
    change_column :participants, :role_id, :bigint
    change_column :users_roles, :user_id, :bigint
    change_column :users_roles, :role_id, :bigint
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
