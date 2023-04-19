class User < ApplicationRecord
    has_many :despesas
    has_secure_password

    validates  :nome, presence: true, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }, if: :funcionario?
    
		def funcionario?
      tipo != "FUNCIONÁRIO"
    end

end
