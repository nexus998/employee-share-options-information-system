class EmployeeDataCsvParser
  require 'csv'
  def initialize(csv_file)
    @csv_file = csv_file
  end

  def parse
    CSV.foreach(@csv_file.path, 'r:bom|utf-8', headers: true) do |row|
      row_hash = row.to_hash
      keys = row_hash.keys
      for key in keys do
        field = Field.find_by(name: key.strip)
        if field.present?
          EmployeeDatum.create!(employee_id: row_hash['Employee ID'], field_id: field.id,
                                value: row_hash[key])
        end
      end
    end
  end
end
