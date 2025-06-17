class FixEventsDates < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :event_date_id, :integer
    remove_column :event_dates, :event_id, :integer

    create_table :event_schedules do |t|
      t.references :event, null: false, foreign_key: true
      t.references :event_date, null: false, foreign_key: true
      t.timestamps
    end

    add_index :event_schedules, [:event_id, :event_date_id], unique: true
  end
end
