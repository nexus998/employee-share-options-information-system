class OptionsCalculation < ApplicationRecord
  belongs_to :grant_type
  # has_and_belongs_to_many :employee_data, join_table: "employee_data_options_calculations", foreign_key: "employee_datum_id"
  has_and_belongs_to_many :employee_data
end
