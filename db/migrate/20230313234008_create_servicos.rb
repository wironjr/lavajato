class CreateServicos < ActiveRecord::Migration[6.1]
  def change
    create_table :servicos do |t|
      t.datetime :data
      t.string :cliente
      t.string :servico
      t.decimal :valor, precision: 10, scale: 2
      t.string :caixa
      t.boolean :pago

      t.timestamps
    end
  end
end
