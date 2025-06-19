class Event < ActiveRecord::Base
  has_many :event_schedule
  has_many :event_dates, through: :event_schedule
  belongs_to :category
  belongs_to :account
  validates :title, presence: true
  validates :description, presence: true
  validates :period, presence: true, inclusion: { in: %w[monthly diary spontaneus] }

  after_create :generate_event_dates

  def generate_event_dates
    today = Date.today
    dates = []

    case period
    when 'monthly'
      12.times { |i| dates << (today >> i) }
    when 'diary'
      dates = (today...(today + 365)).to_a
    when 'spontaneus'
      dates = [today]
    end

    dates.each do |date|
      event_date = EventDate.find_or_create_by(date: date)
      EventSchedule.create(event: self, event_date: event_date)
    end
  end
end