class Event < ActiveRecord::Base
  has_many :event_schedule
  has_many :event_dates, through: :event_schedule
end