class CreateOptionsProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :options_profiles do |t|
      t.string :label
      t.integer :monetary_value

      t.timestamps
    end
  end
end
