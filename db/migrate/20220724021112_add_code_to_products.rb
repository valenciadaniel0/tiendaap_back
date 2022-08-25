class AddCodeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :code, :string
    add_index :products, :code, unique: true
  end
end
