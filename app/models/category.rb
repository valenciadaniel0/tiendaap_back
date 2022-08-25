class Category < ApplicationRecord
  belongs_to :product
  has_many :items

  def no_items?
    items.empty?
  end
end
