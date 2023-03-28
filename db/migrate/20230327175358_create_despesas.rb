class CreateDespesas < ActiveRecord::Migration[6.1]
  def change
    create_table :despesas do |t|
      t.datetime :data
      t.string :observacao
      t.string :tipo
      t.decimal :valor, precision: 10, scale: 2

      t.timestamps
    end
  end
end
