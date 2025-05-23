class Account < ActiveRecord::Base
  belongs_to :user
  has_many :validities
  has_many :offers, through: :validities
end
