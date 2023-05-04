class CreateTiposServicos < ActiveRecord::Migration[6.1]
  def change
    create_table :tipos_servicos do |t|
      t.string :tipo

      t.timestamps
    end
  end
end
