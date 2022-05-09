class GrantType < ApplicationRecord
    has_many :grant_rules, dependent: :destroy
    has_many :options_calculations, dependent: :destroy
end
