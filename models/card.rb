class Card < ActiveRecord::BaseAdd
  self.abstract_class = true 
  self.inheritance_column = :type #Herencia de una sola tabla para credito y debito.

  belongs_to :account # Una tarjeta pertenece a una cuenta.
end