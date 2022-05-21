class OptionsProfileCsvParser
  require 'csv'
  def initialize(file)
    @file = file
  end

  def import
    CSV.foreach(@file.path, 'r:bom|utf-8', headers: true) do |row|
      row_hash = row.to_hash
      profile = row_hash['Options Profile']
      keys = row_hash.keys.select { |key| key != 'Options Profile' }
      values = ''
      for key in keys do
        field = Field.find_by(name: key.strip)
        values += field.id.to_s + '-' + row_hash[key] + ',' if field.present?
      end
      values = values[0..-2] if values[-1] == ','
      if profile.present?
        options_profile = OptionsProfile.find_by(label: profile.strip)
        OptionsProfileMap.create!(options_profile: options_profile, values: values) if options_profile.present?
      end
    end
  end
end
