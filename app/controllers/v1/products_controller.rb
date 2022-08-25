module V1
  class ProductsController < ApplicationController
    before_action :validate_authentication_token

    def index
      products = Product.all
      products = Product.where(user_id: @current_user.id) if @current_user.role == User::ROLES[:store]

      render json: products
    end

    def show
      product = Product.find params[:id]
      render json: product, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'There is no any product with this id' }, status: :not_found
    end

    def update
      product = Product.find_by(id: params[:id])

      if product.update(product_params)
        render json: product, status: :ok
      else
        render json: { error: product.errors }, status: :not_found
      end
    end

    def create
      product = Product.new(product_params)
      product.user_id = @current_user.id
      if product.save
        render json: { "message": "Product has been created successfully.", "product_id": product.id }, status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def product_params
      params.require(:product).permit(:name, :description, :inventory)
    end
  end
end
