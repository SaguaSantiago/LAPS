class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.integer :id_offer
      t.string :company_offer
      t.string :info_offer
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end


