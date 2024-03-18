class AddDepartmentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :department, :string
    add_column :users, :job_title, :string
    add_column :users, :work_status, :string
    add_column :users, :superior, :boolean, default: false
  end
end
