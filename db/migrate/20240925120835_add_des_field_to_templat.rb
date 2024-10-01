class AddDesFieldToTemplat < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :description, :text
  end
end
