class CreateTransaction < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :info_account
      t.time :creation_date
      t.decimal :amount, precision: 15, scale: 2, default: 0.0
      t.references :account, foreign_key: true #relacion con account

      t.string :transaction_type #tipo de transaccion. Transferencia, debito, deposito, etc.

      t.timestamps
    end
  end
end
