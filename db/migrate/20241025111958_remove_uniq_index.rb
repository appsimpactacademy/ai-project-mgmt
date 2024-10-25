class RemoveUniqIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :education_records, :course_name, unique: true
    remove_index :work_experiences, :company_name, unique: true
  end
end
