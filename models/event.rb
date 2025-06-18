class Event < ActiveRecord::Base
  has_many :event_schedule
  has_many :event_dates, through: :event_schedule
  belongs_to :category
  belongs_to :account
  validates :title, presence: true
  validates :description, presence: true
  validates :period, presence: true, inclusion: { in: %w[monthly diary spontaneus] }
end