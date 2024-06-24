class RenameProjectCompany < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :company, :client_company
  end
end
