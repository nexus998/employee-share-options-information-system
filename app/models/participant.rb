class Participant < ApplicationRecord
  belongs_to :role
  def self.import(file)
    ParticipantBulkCsvParser.new(file).import
  end
end
