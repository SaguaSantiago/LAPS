class CreateEventDates < ActiveRecord::Migration[7.0]
  def change
    create_table :event_dates do |t|
      t.references :event, foreign_key: true
      t.references :transaction, foreign_key: true
      t.date :date
    end
  end
end
