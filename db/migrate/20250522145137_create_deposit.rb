class CreateDeposit < ActiveRecord::Migration[7.0]
  def change
    create_table :deposit do |t|
      t.string :method
      t.integer :reference #nro de comprobante
      t.reference :transaction, foreign_key: true #relacion con transaction

      t.timestamps
end
