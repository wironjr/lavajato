class Servico < ApplicationRecord
    validates :cliente, presence: true
    validates :valor, presence: true
    validates :servico, presence: true
end
