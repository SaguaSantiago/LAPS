class EventDate < ActiveRecord::Base
  has_many :event_schedule
  has_many :events, through: :event_schedule

  validates :date, presence: true
end