class AddTriggerToGrantRules < ActiveRecord::Migration[7.0]
  def change
    add_column :grant_rules, :trigger, :string
  end
end
