class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :picture, :stock, :price

  has_many :items
  belongs_to :product
end
