class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :cardNumber
      t.date :expirationDate
      t.string :cvv
      t.boolean :isActive

      t.string :type # para manejar los submodelos

       # Campos específicos por tipo de tarjeta
      t.integer :availableCredit # -> atributo de tarjeta de credito

      t.references :account, foreign_key: true

      t.timestamps
  end
end
