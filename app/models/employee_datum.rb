class EmployeeDatum < ApplicationRecord
  belongs_to :field
  # has_and_belongs_to_many :options_calculations, join_table: "employee_data_options_calculations", foreign_key: "options_calculation_id"
  has_and_belongs_to_many :options_calculations

  scope :with_no_assigned_calculations, -> { left_joins(:options_calculations).where(options_calculations: nil) }
  scope :with_assigned_calculations, -> { left_joins(:options_calculations).where.not(options_calculations: nil) }

  def self.import(file)
    EmployeeDataCsvParser.new(file).parse
  rescue StandardError => e
    print e
  end

  def self.hire_date(emp_id)
    where(employee_id: emp_id, field_id: Field.find_by(name: 'Hire date').id).last.value
  end

  def self.emp_map
    emp_map = []
    all = EmployeeDatum.with_no_assigned_calculations
    unique_employees = all.map { |e| e.employee_id }.uniq
    unique_employees.each do |emp|
      # fields = EmployeeDatum.where(employee_id: emp)
      # fields = all.select {|f| f.employee_id == emp}
      fields = all.where(employee_id: emp)
      temp = []
      fields.each do |field|
        temp.push([field.field.name, field.value])
      end
      emp_map.push(temp)
    end
    emp_map
  end
end
