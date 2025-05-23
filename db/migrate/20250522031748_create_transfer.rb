class CreateTransfer < ActiveRecord::Migration[7.0]
  def change
    create_table :transfer do |t|
      t.string :method
      t.references :transaction, foreign_key: true #relacion con transaction

      t.timestamps
    end
  end
end
