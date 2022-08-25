class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :picture
      t.integer :stock
      t.decimal :price
      t.integer :product_id

      t.timestamps
    end
  end
end
