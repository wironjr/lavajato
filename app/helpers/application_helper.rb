module ApplicationHelper
    def numero_real(num,qtd_descimal)
        number_to_currency(num, unit: "R$ ", separator: ",", delimiter: ".",precision: qtd_descimal)
    end
end
