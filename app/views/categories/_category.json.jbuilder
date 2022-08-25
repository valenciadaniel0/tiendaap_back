json.extract! category, :id, :name, :picture, :stock, :price, :product_id, :created_at, :updated_at
json.url category_url(category, format: :json)
