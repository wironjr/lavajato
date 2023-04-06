class AddFuncionarioToDespesas < ActiveRecord::Migration[6.1]
  def change
    add_column :despesas, :funcionario, :string, default: ''
  end
end
