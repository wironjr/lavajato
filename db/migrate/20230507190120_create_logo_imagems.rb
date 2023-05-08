class CreateLogoImagems < ActiveRecord::Migration[6.1]
  def change
    create_table :logo_imagems do |t|

      t.string :nome

      t.timestamps
    end
  end
end
