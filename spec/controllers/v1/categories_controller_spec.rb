require 'rails_helper'

describe V1::CategoriesController, type: :controller do
  let(:user) { create :user }
  let(:response_body) { JSON.parse response.body }
  let(:response_error) { response_body['error'] }

  before do
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.authentication_token}"
  end

  describe 'GET index' do
    let(:user2) { create :user }
    let(:product) { create :product, user: user }
    let!(:category) { create :category, product: product }
    let(:product2) { create :product, user: user2 }
    let!(:category2) { create :category, product: product2 }

    context 'when the logged user is a store' do
      it 'gets the category' do
        get :index
        expect(response_body.size).to eq(1)
      end
    end

    context 'when the logged user is an admin' do
      let(:admin_user) { create :user, role: User::ROLES[:admin] }
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{admin_user.authentication_token}"
      end

      it 'gets all the categories' do
        get :index
        expect(response_body.size).to eq(2)
      end
    end
  end

  describe 'GET show' do
    let(:admin_user) { create :user, role: User::ROLES[:admin] }
    let(:user2) { create :user }
    let(:product) { create :product, user: user }
    let(:category) { create :category, product: product }

    context 'when the logged user is an admin' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{admin_user.authentication_token}"
      end
      it 'returns the category' do
        get :show, params: { id: category.id }
        expect(response).to have_http_status(:ok)
        expect(response_body['id']).to eq(category.id)
      end
    end

    context 'when the logged user is from a store and is the owner of the associated product' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.authentication_token}"
      end
      it 'returns the category' do
        get :show, params: { id: category.id }
        expect(response).to have_http_status(:ok)
        expect(response_body['id']).to eq(category.id)
      end
    end

    context 'when the logged user is from a store and is not the owner of the associated product' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user2.authentication_token}"
      end
      it 'returns the error message' do
        get :show, params: { id: category.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST create' do
    let(:product) { create :product, user: user }

    params = {
      name: 'Test category',
      stock: 0,
      price: 10_000,
      picture: "testpicture.png",
      product_id: nil
    }

    context "when the data is correct" do
      it 'creates a new category' do
        params[:product_id] = product.id
        post :create, params: { category: params }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the user creating the category is not the same of the product' do
      let!(:user2) { create :user }
      let(:product2) { create :product, user: user2 }

      it 'returns unauthorized to modify the product message' do
        params[:product_id] = product2.id
        post :create, params: { category: params }
        expect(response_error).to eq('You are not authorized to modify this product')
      end
    end

    context 'when the product of the category does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        params[:product_id] = 0
        post :create, params: { category: params }
        expect(response_error).to eq('Product does not exist')
      end
    end
  end

  describe 'PUT #update' do
    let(:admin_user) { create :user, role: User::ROLES[:admin] }
    let(:user2) { create :user }
    let(:product) { create :product, user: user }
    let(:category) { create :category, product: product, price: 3_000 }

    let(:params) do
      {
        name: 'category test',
        product_id: product.id,
        picture: 'test picture',
        stock: 1,
        price: 2_000
      }
    end

    context 'when the logged user is an admin' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{admin_user.authentication_token}"
      end

      it 'updates the category' do
        put :update, params: { id: category.id, category: params }
        expect(response).to have_http_status(:ok)
        expect(response_body['price'].to_i).to eq(2_000)
      end
    end

    context 'when the logged user is a store and is the owner of the associated product' do
      it 'updates the category' do
        put :update, params: { id: category.id, category: params }
        expect(response).to have_http_status(:ok)
        expect(response_body['price'].to_i).to eq(2_000)
      end
    end

    context 'when the logged user is a store and is not the owner of the associated product' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user2.authentication_token}"
      end

      it 'returns error' do
        put :update, params: { id: category.id, category: params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_error).to eq('Cannot update this category')
      end
    end
  end
end
