class AddRoleToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_reference :participants, :role, null: false, foreign_key: true
  end
end
