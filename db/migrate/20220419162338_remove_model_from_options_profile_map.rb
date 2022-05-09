class RemoveModelFromOptionsProfileMap < ActiveRecord::Migration[7.0]
  def change
    remove_column :options_profile_maps, :model
    add_column :options_profile_maps, :values, :text
    add_reference :options_profile_maps, :options_profiles, index: true, foreign_key: true
  end
end
