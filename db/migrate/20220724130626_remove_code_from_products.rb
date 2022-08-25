class RemoveCodeFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :code
  end
end
