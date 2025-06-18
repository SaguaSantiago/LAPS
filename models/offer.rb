class Offer < ActiveRecord::Base
  belongs_to :account
  has_many :validitiesAdd
  has_many :accounts, through: :validities
end