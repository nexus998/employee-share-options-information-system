class OptionsProfileMap < ApplicationRecord
  belongs_to :options_profile, foreign_key: 'options_profiles_id'
  require 'csv'
  def self.import(file)
    OptionsProfileCsvParser.new(file).import
  end
end
