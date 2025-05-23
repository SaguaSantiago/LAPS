class CreateLoan < ActiveRecord::Migration[7.0]
  def change
    create_table :loan do |t|
      t.integer :quotas_number
      t.date :expiration_period
      t.decimal :interest, precision: 5, scale: 2
      t.reference :transaction, foreign_key: true #relacion con transaction

      t.timestamps
  end
end
