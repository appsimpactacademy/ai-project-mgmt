class AddAboutFieldToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :about, :text
  end
end
