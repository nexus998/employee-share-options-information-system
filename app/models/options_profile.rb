class OptionsProfile < ApplicationRecord
    has_many :options_profile_maps, foreign_key: 'options_profiles_id'
end
