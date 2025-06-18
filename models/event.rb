class Event < ActiveRecord::Base
  belongs_to :account
  has_one :category
  has_many :event_dates
end