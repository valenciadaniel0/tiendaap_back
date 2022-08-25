class AddInventoryColumnToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :inventory, :boolean
  end
end
