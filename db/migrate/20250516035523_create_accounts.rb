class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :idAccount
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.string :cvu
      t.string :alias
      t.date :creationDate
      t.references :user, foreign_key: true  # Relación con User

      t.timestamps
    end
  end
end
