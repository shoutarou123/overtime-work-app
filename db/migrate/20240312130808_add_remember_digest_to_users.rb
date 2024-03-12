class AddRememberDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_digest, :string
    add_column :users, :base_pay, :integer
  end
end
