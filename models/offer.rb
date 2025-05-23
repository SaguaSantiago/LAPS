# models/offer.rb
class Offer < ActiveRecord::Base
  belongs_to :account
  has_many :validities
  has_many :accounts, through: :validities
end

