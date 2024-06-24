class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :client_name
      t.string :company
      t.date :start_date
      t.date :end_date
      t.string :status

      t.timestamps
    end
  end
end
