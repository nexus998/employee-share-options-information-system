class GrantRule < ApplicationRecord
  belongs_to :grant_type, foreign_key: :grant_type_id
end
