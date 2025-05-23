class EventDate < ActiveRecord::Base
  has_many :events
  has_many :transactions
  
end