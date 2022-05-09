class AddCliffPercentageToGrantType < ActiveRecord::Migration[7.0]
  def change
    add_column :grant_types, :cliff_percentage, :float
  end
end
