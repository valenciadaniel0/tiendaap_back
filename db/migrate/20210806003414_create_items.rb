class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :code
      t.integer :status

      t.timestamps
    end
  end
end
