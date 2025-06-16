class Event < ActiveRecord::BaseAdd
  belongs_to :account
  has_one :category
  has_many :eventDate
end