class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :clientId
      t.integer :cuit
      t.date :creationDate
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end

