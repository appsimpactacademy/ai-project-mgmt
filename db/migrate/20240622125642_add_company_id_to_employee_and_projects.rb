class AddCompanyIdToEmployeeAndProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :company_id, :integer
    add_column :employees, :company_id, :integer
  end
end
