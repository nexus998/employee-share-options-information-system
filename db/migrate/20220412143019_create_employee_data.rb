class CreateEmployeeData < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_data do |t|
      t.string :employee_id
      t.references :field, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
