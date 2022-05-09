class CreateGrantRules < ActiveRecord::Migration[7.0]
  def change
    create_table :grant_rules do |t|
      t.references :grant_type, null: false, foreign_key: true
      t.date :vesting_start
      t.string :cliff
      t.string :tranches

      t.timestamps
    end
  end
end
