class User < ActiveRecord::Base
  has_secure_password

  has_one :account

  validates :email, presence: true, uniqueness: true
  validates :dni, presence: true, uniqueness: true
  validates :cuit, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }

  after_create :create_account_and_categories

  private

  def create_account_and_categories
    acc = self.create_account unless self.account
    acc ||= self.account
    Category.create(name: 'Alimentación', description: 'Gastos en restaurant, supermercado y otros rubros gastronomicos', account_id: acc.id)
    Category.create(name: 'Transporte', description: 'Gastos en buses, aereopuertos, etc.', account_id: acc.id)
    Category.create(name: 'Servicios', description: 'Gastos en gas, luz, etc.', account_id: acc.id)
    Category.create(name: 'Salud', description: 'Gastos en farmacia y medicina', account_id: acc.id)
    Category.create(name: 'Varios', description: 'Gastos sin categorizar', account_id: acc.id)
  end
end