class Item < ApplicationRecord
  belongs_to :category

  validates :code, uniqueness: true

  def product
    category&.product
  end
end
