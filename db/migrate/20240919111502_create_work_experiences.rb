class CreateWorkExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :work_experiences do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :job_title
      t.string :role
      t.string :description
      t.string :company_name
      t.date :start_date
      t.date :end_date
      t.boolean :is_currently_working_here, default: false

      t.timestamps
    end
  end
end
