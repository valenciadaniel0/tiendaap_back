class ItemSerializer < ActiveModel::Serializer
  attributes :id, :code, :status

  belongs_to :category
  belongs_to :product, through: :category
end
