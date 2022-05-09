class CreateOptionsProfileMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :options_profile_maps do |t|
      t.text :model

      t.timestamps
    end
  end
end
