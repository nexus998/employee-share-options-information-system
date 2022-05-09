class RemoveFieldIdFromGrantRules < ActiveRecord::Migration[7.0]
  def change
    remove_column :grant_rules, :field_id
  end
end
