require 'rails_helper'

describe V1::ProductsController, type: :controller do
  let(:user) { create :user }
  let(:response_body) { JSON.parse(response.body) }
  let(:response_error) { response_body['error'] }

  before do
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.authentication_token}"
  end

  describe 'POST create' do
    let(:params) do
      {
        name: 'Test product',
        inventory: 1,
        description: 'Test product description'
      }
    end

    context 'when the data is correct' do
      it "returns a 201" do
        post :create, params: { product: params }
        expect(response).to have_http_status(:created)
      end
    end
  end
  describe 'PUT update' do
    let!(:product) { create :product, user: user }

    let(:params) do
      {
        name: 'Test product',
        inventory: 1,
        description: 'Test product description'
      }
    end
    context 'when a valid payload is sent' do
      it 'updates the product' do
        put :update, params: { id: product.id, product: params }
        expect(response).to have_http_status(:ok)
        expect(product.reload.name).to eq('Test product')
      end
    end
  end
  describe 'GET show' do
    context 'when the product exists' do
      let(:product) { create :product, user: user }
      it 'returns the product' do
        get :show, params: { id: product.id }
        expect(response_body['id']).to eq(product.id)
      end
    end
    context 'when the product does not exist' do
      it 'returns product does not exist message' do
        get :show, params: { id: 0 }
        expect(response_error).to eq('There is no any product with this id')
      end
    end
  end
  describe 'GET index' do
    let(:admin_user) { create :user, role: 1 }
    let!(:product1) { create :product, user: user }
    let!(:product2) { create :product, user: admin_user }
    context 'when the user is admin' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{admin_user.authentication_token}"
      end

      it 'gets all the products' do
        get :index
        expect(response_body.count).to eq(2)
      end
    end
    context 'when the user is store' do
      it 'gets the product linked to the store user' do
        get :index
        expect(response_body.count).to eq(1)
      end
    end
  end
end
