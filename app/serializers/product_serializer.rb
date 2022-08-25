class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :inventory, :user_id

  has_many :categories
end
