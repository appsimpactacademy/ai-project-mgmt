class AddUniqueIndexToCourses < ActiveRecord::Migration[7.0]
  def change
    add_index :education_records, :course_name, unique: true
  end
end
