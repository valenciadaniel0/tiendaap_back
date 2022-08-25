require 'rails_helper'

describe V1::UsersController, type: :controller do
  describe 'POST create' do
    params = {
      "name": "Test store",
      "email": "teststore@email.com",
      "username": "teststore",
      "password": "123456",
      "role": 2
    }
    context "when the data is correct" do
      it 'returns a 201' do
        post :create, params: { user: params }
        expect(response).to have_http_status(:created)
      end
    end
    context "when the email was already used" do
      it 'returns 422' do
        FactoryBot.create(:user, email: 'teststore@email.com')
        post :create, params: { user: params }
        expect(response).to have_http_status(422)
      end
    end
  end
  describe 'GET show' do
    context 'when the user exists' do
      let(:user) { create :user }
      context 'when the login data is correct' do
        it 'returns a 200' do
          get :show, params: { id: user.id, email: user.email, password: '123456' }
          expect(response).to have_http_status(:ok)
        end
      end
      context "when the login data is incorrect" do
        it 'returns a 401' do
          get :show, params: { id: user.id, email: user.email, password: '12345' }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'when the user does not exist' do
      it 'return a 401' do
        get :show, params: { id: 0, email: 'user0@email.com', password: '123456' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
