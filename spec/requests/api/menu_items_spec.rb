require 'rails_helper'

RSpec.describe "Api::MenuItemsController", type: :request do
  let!(:menu) { create(:menu) }
  let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }
  let(:menu_item_id) { menu_items.first.id }

  describe 'GET /api/menu_items' do
    before { get '/api/menu_items' }

    it 'returns all menu items' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/menu_items/:id' do
    context 'when the menu item exists' do
      before { get "/api/menu_items/#{menu_item_id}" }

      it 'returns the menu item' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(menu_item_id)
      end
    end

    context 'when the menu item does not exist' do
      before { get "/api/menu_items/0" }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
      end
    end
  end

  describe 'POST /api/menu_items' do
    let(:valid_attributes) do
      { menu_item: { name: 'Burger', description: 'Tasty burger', price: 9.99, menu_id: menu.id } }
    end
    let(:invalid_attributes) { { menu_item: { name: nil, price: -1, menu_id: menu.id } } }

    context 'when the parameters are valid' do
      before { post '/api/menu_items', params: valid_attributes }

      it 'creates a new menu item' do
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('Burger')
      end
    end

    context 'when the parameters are invalid' do
      before { post '/api/menu_items', params: invalid_attributes }

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'PUT /api/menu_items/:id' do
    let(:valid_attributes) { { menu_item: { name: 'Pizza' } } }
    let(:invalid_attributes) { { menu_item: { name: nil } } }

    context 'when the menu item exists' do
      context 'with valid parameters' do
        before { put "/api/menu_items/#{menu_item_id}", params: valid_attributes }

        it 'updates the menu item' do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['name']).to eq('Pizza')
        end
      end

      context 'with invalid parameters' do
        before { put "/api/menu_items/#{menu_item_id}", params: invalid_attributes }

        it 'returns status unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('errors')
        end
      end
    end

    context 'when the menu item does not exist' do
      before { put "/api/menu_items/0", params: valid_attributes }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
      end
    end
  end

  describe 'DELETE /api/menu_items/:id' do
    context 'when the menu item exists' do
      before { delete "/api/menu_items/#{menu_item_id}" }

      it 'deletes the menu item' do
        expect(response).to have_http_status(:no_content)
        expect(MenuItem.find_by(id: menu_item_id)).to be_nil
      end
    end

    context 'when the menu item does not exist' do
      before { delete "/api/menu_items/0" }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
      end
    end
  end
end