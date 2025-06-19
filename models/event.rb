class Event < ActiveRecord::Base
  has_many :event_schedules
  has_many :event_dates, through: :event_schedules
  belongs_to :category
  belongs_to :account
  validates :title, presence: true
  validates :description, presence: true
  validates :period, presence: true, inclusion: { in: %w[monthly diary spontaneus] }

  after_create :generate_event_dates

  def generate_event_dates
    start_date = instance_variable_get(:@start_date) || Date.today
    dates = []

    case period
    when 'monthly'
      12.times { |i| dates << (start_date >> i) }
    when 'diary'
      dates = (start_date...(start_date + 365)).to_a
    when 'spontaneus'
      dates = [start_date]
    end

    dates.each do |date|
      event_date = EventDate.find_or_create_by(date: date)
      EventSchedule.create(event: self, event_date: event_date)
    end
  end
end