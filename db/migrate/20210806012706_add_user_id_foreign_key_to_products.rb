class AddUserIdForeignKeyToProducts < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :products, :users
  end
end
