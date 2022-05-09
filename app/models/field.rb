class Field < ApplicationRecord
    has_many :employee_data, dependent: :destroy
end
