class CrateTransaction < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction do |t|
      t.string :info_account
      t.time :cration_date
      t.decimal :amount, precision: 15, scale: 2, default: 0.0
      t.references :account, foreign_key: true #relacion con account

      t.string :type #tipo de transaccion. Transferencia, debito, deposito, etc.

      t.timestamps
    end
  end
end
