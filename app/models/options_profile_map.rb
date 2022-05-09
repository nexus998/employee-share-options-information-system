class OptionsProfileMap < ApplicationRecord
    belongs_to :options_profile, foreign_key: 'options_profiles_id'
    require 'csv'
    def self.import(file)
        CSV.foreach(file.path, "r:bom|utf-8", headers: true) do |row|
            row_hash = row.to_hash
            profile = row_hash['Options Profile']
            keys = row_hash.keys.select {|key| key != 'Options Profile'}
            values = ""
            for key in keys do
                field = Field.find_by(name: key.strip)
                if field.present?
                    values += field.id.to_s + '-' + row_hash[key] + ","
                end
            end
            if values[-1] == ","
                values = values[0..-2]
            end
            if profile.present?
                options_profile = OptionsProfile.find_by(label: profile.strip)
                puts options_profile
                if options_profile.present?
                    OptionsProfileMap.create!(options_profile: options_profile, values: values)
                end
            end
        end
    end
end