require 'rails_helper'

describe V1::ItemsController, type: :controller do
  let(:user) { create :user }
  let(:product) { create :product, user: user }
  let(:category) { create :category, product: product }

  let(:response_body) { JSON.parse response.body }

  before do
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.authentication_token}"
  end

  describe 'Post #create' do
    let(:params) do
      lambda do |category_id|
        {
          code: 123,
          status: 1,
          category_id: category_id
        }
      end
    end

    context 'when the data is correct' do
      it 'returns a 201' do
        post :create, params: { item: params[category.id] }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the category already has items and the product is not inventory' do
      let(:not_inventory_product) { create :product, user: user, inventory: Product::TYPES[:not_inventory] }
      let(:not_inventory_category) { create :category, product: not_inventory_product }
      let!(:item) { create :item, category: not_inventory_category }

      it 'returns a 422' do
        post :create, params: { item: params[not_inventory_category.id] }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'Get #find_by_code' do
    context 'when there is an item matching the code' do
      let(:item) { create :item, category: category }
      it 'gets the item' do
        get :find_by_code, params: { code: item.code }
        expect(JSON.parse(response.body)['id']).to eq(item.id)
      end
    end
    context 'when there is no any item matching the code' do
      it 'returns no item found message' do
        get :find_by_code, params: { code: 0 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('There is no any item with this code')
      end
    end
    context 'when the matching product does not belong to the authenticated user and the user is not an admin' do
      let(:user1) { create :user }
      let(:product1) { create :product, user: user1 }
      let(:category1) { create :category, product: product1 }
      let(:item) { create :item, category: category1 }

      it 'returns a 404' do
        get :find_by_code, params: { code: item.code }
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the matching product does not belong to the authenticated user and the user is an admin' do
      let(:user1) { create :user }
      let(:admin_user) { create :user, role: 1 }
      let(:product1) { create :product, user: user1 }
      let(:category1) { create :category, product: product1 }
      let(:item) { create :item, category: category1 }

      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{admin_user.authentication_token}"
      end

      it 'returns a 200' do
        get :find_by_code, params: { code: item.code }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT #update' do
    let(:catgegory) { create :category, :with_product }
    let(:category2) { create :category, :with_product }
    let(:item) { create :item, category: category2 }
    let(:params) do
      lambda do |category_id|
        {
          code: '123',
          status: 2,
          category_id: category_id
        }
      end
    end

    context 'when the data is correct' do
      it 'updates the item' do
        put :update, params: { id: item.id, item: params[category.id] }
        expect(response).to have_http_status(:ok)
        expect(item.reload.category_id).to eq(category.id)
      end
    end

    context 'when there is no any item with the provided id' do
      it 'returns error message' do
        put :update, params: { id: 0, item: params[category.id] }
        expect(response_body['error']).to eq('There is no any item with this id: 0')
      end
    end
  end
end
