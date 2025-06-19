class User < ActiveRecord::Base
  has_secure_password

  has_one :account, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :dni, presence: true, uniqueness: true
  validates :cuit, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }

  after_create :create_account_and_categories

  private

  def create_account_and_categories
     acc = self.account || self.create_account!(
      balance: 0.0,
      cvu: generar_cvu_unico,
      alias: generar_alias_unico
    )

    acc ||= self.account
    Category.create!(name: 'Alimentación', description: 'Gastos en restaurant, supermercado y otros rubros gastronomicos',color: "#FFB347", account_id: acc.id)
    Category.create!(name: 'Transporte', description: 'Gastos en buses, aereopuertos, etc.', color: "#5BC0EB", account_id: acc.id)
    Category.create!(name: 'Servicios', description: 'Gastos en gas, luz, etc.', color: "#E65C5C", account_id: acc.id)
    Category.create!(name: 'Salud', description: 'Gastos en farmacia y medicina', color: "#7ED957", account_id: acc.id)
    Category.create!(name: 'Varios', description: 'Gastos sin categorizar', color: "#C28FFF", account_id: acc.id)
  end


  def generar_cvu_unico
    loop do
      cvu = Array.new(22) { rand(0..9) }.join
      break cvu unless Account.exists?(cvu: cvu)
    end
  end

  def generar_alias_unico
    loop do
      nombre_base = self.username ? self.username.downcase.gsub(" ", "_") : "usuario"
      alias_generado = "#{nombre_base}_#{rand(1000..9999)}"
      break alias_generado unless Account.exists?(alias: alias_generado)
    end
  end
end