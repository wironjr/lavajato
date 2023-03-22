class AddColumnToServicos < ActiveRecord::Migration[6.1]
  def change
    add_column :servicos, :veiculo, :string, default: ''
  end
end
