class AddUniqueIndexToWorkExp < ActiveRecord::Migration[7.0]
  def change
    add_index :work_experiences, :company_name, unique: true
  end
end
