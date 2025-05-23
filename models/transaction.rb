class Transaction < ActiveRecord::Base
    self.abstract_class = true

    validates :amount, presence: true, numericality: { greater_than: 0 }

    def execute
        raise NotImplementedError, "subclase must be implement 'execute'"
    end
end