class User < ActiveRecord::Base
     has_secure_password

     has_one :account

     validates :email, presence: true, uniqueness: true
     validates :dni, presence: true, uniqueness: true
     validates :cuit, presence: true, uniqueness: true
     validates :username, presence: true, uniqueness: true
     validates :password, length: {minimum: 6 }
end



