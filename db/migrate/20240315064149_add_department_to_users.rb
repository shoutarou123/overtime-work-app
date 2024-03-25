class AddDepartmentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :department, :string # 所属
    add_column :users, :job_title, :string # 職名
    add_column :users, :work_status, :string # 当,1,2,3,4,週,日,年
    add_column :users, :superior, :boolean, default: false # 所属長権限
    add_column :users, :office_staff, :boolean, default: false # 庶務係権限
  end
end
