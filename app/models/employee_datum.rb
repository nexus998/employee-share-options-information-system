class EmployeeDatum < ApplicationRecord
    belongs_to :field
    # has_and_belongs_to_many :options_calculations, join_table: "employee_data_options_calculations", foreign_key: "options_calculation_id"
    has_and_belongs_to_many :options_calculations
    require 'csv'
    def self.import(file)
        CSV.foreach(file.path, "r:bom|utf-8", headers: true) do |row|
            row_hash = row.to_hash
            keys = row_hash.keys
            for key in keys do
                field = Field.find_by(name: key.strip)
                if field.present?
                    EmployeeDatum.create!(employee_id: row_hash['Employee ID'], field_id: field.id, value: row_hash[key])
                end
            end
        end
    end

    def self.emp_map()
        emp_map = Array.new
        all = EmployeeDatum.left_joins(:options_calculations).where(options_calculations: nil)
        unique_employees = all.map {|e| e.employee_id}.uniq
        unique_employees.each do |emp|
           # fields = EmployeeDatum.where(employee_id: emp)
            #fields = all.select {|f| f.employee_id == emp}
            fields = all.where(employee_id: emp)
            temp = Array.new
            fields.each do |field|
                temp.push([field.field.name, field.value])
            end
            emp_map.push(temp)
        end
        return emp_map
    end
end
