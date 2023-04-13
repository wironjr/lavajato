class AddDesligamentoToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :desligamento, :date, default: "3000-01-01"
    #Ex:- :default =>''
  end
end
