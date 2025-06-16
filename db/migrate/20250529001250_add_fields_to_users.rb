class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :dni, :string
    add_column :users, :username, :string
    add_column :users, :password_digest, :string
  end
end
