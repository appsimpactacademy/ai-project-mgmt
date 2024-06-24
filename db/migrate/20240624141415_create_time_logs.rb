class CreateTimeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_logs do |t|
      t.string :description
      t.float :time_in_hours
      t.string :status
      t.date :log_date
      t.string :task_type
      t.references :employee, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :employee_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
