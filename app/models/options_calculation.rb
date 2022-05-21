class OptionsCalculation < ApplicationRecord
  scope :verified, -> { where(verified: true) }
  scope :unverified, -> { where(verified: false) }
  scope :belonging_to, ->(employee_id) { where(employee_id: employee_id) }
  scope :belonging_to_user, ->(user) { belonging_to(user.employee_id) }

  belongs_to :grant_type
  has_and_belongs_to_many :employee_data

  def self.get_relevant_column_names
    col_names = OptionsCalculation.column_names
    column_names = []
    col_names.each do |c|
      column_names.push(c.dup)
    end
    column_names = column_names[2..]
    column_names = column_names.filter { |c| c != 'created_at' && c != 'updated_at' && c != 'verified' }
    column_names[column_names.index('grant_type_id')].sub!('grant_type_id', 'grant_type')

    column_names
  end

  def self.get_pretty_column_names
    col_names = OptionsCalculation.column_names
    column_names_edited = []
    col_names.each do |c|
      column_names_edited.append(c.gsub('_', ' ').titleize)
    end
    column_names_edited = column_names_edited[2..]
    column_names_edited.filter { |c| c != 'Created At' && c != 'Updated At' && c != 'Verified' }
  end
end
