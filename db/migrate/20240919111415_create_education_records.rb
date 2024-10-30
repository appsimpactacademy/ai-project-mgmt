class CreateEducationRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :education_records do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :course_name
      t.integer :start_year
      t.integer :end_year
      t.integer :marks
      t.boolean :is_pursuing, default: false
      t.string :college_or_university

      t.timestamps
    end
  end
end
