class CreateOptionsCalculations < ActiveRecord::Migration[7.0]
  def change
    create_table :options_calculations do |t|
      t.string :employee_id
      t.date :grant_date
      t.date :vesting_start_date
      t.integer :cliff
      t.integer :tranches
      t.references :grant_type, null: false, foreign_key: true
      t.decimal :share_number
      t.date :vesting_end_date

      t.timestamps
    end
  end
end
