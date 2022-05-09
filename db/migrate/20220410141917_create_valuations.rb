class CreateValuations < ActiveRecord::Migration[7.0]
  def change
    create_table :valuations do |t|
      t.decimal :market_price
      t.decimal :strike_price
      t.date :effective_date
      t.string :description

      t.timestamps
    end
  end
end
