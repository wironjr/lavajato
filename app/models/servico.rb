class Servico < ApplicationRecord
    validates :cliente, presence: true
    validates :valor, presence: true
    validates :servico, presence: true
    validates :veiculo, presence: true

    has_one_attached :imagem
end
