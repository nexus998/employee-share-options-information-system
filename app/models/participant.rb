class Participant < ApplicationRecord
    belongs_to :role
    require 'csv'
    def self.import(file)
        CSV.foreach(file.path, "r:bom|utf-8", headers: true) do |row|
            row_hash = row.to_hash
            role_by_name = Role.where(name: row_hash["Role"]).first
            Participant.create!(email: row_hash["Email"], employee_id: row_hash["Employee ID"], role: role_by_name)
        end
    end
end
