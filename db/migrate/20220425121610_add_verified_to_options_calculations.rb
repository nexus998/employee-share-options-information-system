class AddVerifiedToOptionsCalculations < ActiveRecord::Migration[7.0]
  def change
    add_column :options_calculations, :verified, :boolean
  end
end
