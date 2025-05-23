class CreateDebt < ActiveRecord::Migration[8.0]
  def change
    create_table :debt do |t|
      t.date :maturuty_date
      t.decimal :interest, precision: 5, scale: 2
      t.decimal :outstanding_balance, precision: 15, scale: 2

      t.timestamps
  end
end
