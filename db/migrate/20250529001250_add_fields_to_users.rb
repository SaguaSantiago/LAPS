class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_colum :users, :dni, :string
    add_colum :users, :username, :string
    add_colum :users, :password_digest, :string
  end
end
