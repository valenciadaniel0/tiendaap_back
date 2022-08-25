module V1
  class CategoriesController < ApplicationController
    before_action :validate_authentication_token
    before_action :set_category, only: %i[show update]

    def index
      if @current_user.role == User::ROLES[:admin]
        render json: Category.all, status: :ok
      else
        product_ids = @current_user.products.pluck(:id)
        render json: Category.where(product_id: product_ids), status: :ok
      end
    end

    def show
      if user_allowed?
        render json: @category, status: :ok
      else
        render json: { 'error': 'Cannot get this category' }, status: :unprocessable_entity
      end
    end

    def create
      product = Product.find category_params[:product_id]
      if product.user_id == @current_user.id
        category = Category.new(category_params)
        if category.save
          render json: { "message": "Category has been created_successfully.", "product_id": category.id }, status: :created
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { "error": "You are not authorized to modify this product" }, status: :unprocessable_entity unless product.user_id == @current_user.id
      end
    rescue ActiveRecord::RecordNotFound
      render json: { "error": "Product does not exist" }, status: :unprocessable_entity
    end

    def update
      if user_allowed?
        render json: @category, status: :ok if @category.update(category_params)
      else
        render json: { 'error': 'Cannot update this category' }, status: :unprocessable_entity
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :product_id, :picture, :stock, :price)
    end

    def set_category
      @category = Category.find params[:id]
    end

    def user_allowed?
      @category && (@current_user.role == User::ROLES[:admin] || @category.product.user_id == @current_user.id)
    end
  end
end
