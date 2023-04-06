class AddTipoToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tipo, :string, default: ''
  end
end
