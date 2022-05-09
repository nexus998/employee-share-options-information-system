class RemoveNullFromEmployeeData < ActiveRecord::Migration[7.0]
  def change
    change_column_null :employee_data, :field_id, true
  end
end
