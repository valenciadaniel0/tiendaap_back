class Product < ApplicationRecord
  TYPES = HashWithIndifferentAccess.new({ inventory: 1, not_inventory: 2 })

  belongs_to :user

  has_many :categories
  has_many :items, through: :categories
end
