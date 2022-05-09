class AddShareNumberToGrantRules < ActiveRecord::Migration[7.0]
  def change
    add_column :grant_rules, :share_number, :string
  end
end
