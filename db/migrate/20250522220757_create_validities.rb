class CreateValidities < ActiveRecord::Migration[7.0]
  def change
    create_table :validities do |t|
    	t.date :start_offer
    	t.date :end_offer
    	t.references :account, null: false, foreign_key: true
    	t.references :offer, null: false, foreign_key: true

      t.timestamps
    end
  end
end