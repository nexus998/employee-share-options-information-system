class FixGrantRules < ActiveRecord::Migration[7.0]
  def change
    change_column :grant_rules, :vesting_start, :string
    add_column :grant_rules, :field_id, :integer, null: true
  end
end
