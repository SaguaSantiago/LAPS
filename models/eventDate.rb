class EventDate < ActiveRecord::Base
  has_many :event_schedules
  has_many :events, through: :event_schedules

  validates :date, presence: true
end