class CreateEmployeeSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_skills do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
