class AddProductIdToCategories < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :categories, :products
  end
end
