class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.string :email
      t.string :employee_id

      t.timestamps
    end
  end
end
