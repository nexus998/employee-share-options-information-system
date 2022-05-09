class RenameFieldType < ActiveRecord::Migration[7.0]
  def change
    rename_column :fields, :type, :field_type
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
