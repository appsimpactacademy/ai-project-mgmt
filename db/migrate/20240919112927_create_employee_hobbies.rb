class CreateEmployeeHobbies < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_hobbies do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :hobby, null: false, foreign_key: true

      t.timestamps
    end
  end
end
