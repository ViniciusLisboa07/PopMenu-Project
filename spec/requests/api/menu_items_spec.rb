require 'rails_helper'

RSpec.describe "Api::Menu itemsController", type: :request do
  let!(:menu) { create(:menu) }
  let!(:menu_items) { create_list(:menu_item, 3, :with_menus, menus: [menu]) }
  let(:menu_item_id) { menu_items.first.id }
  let(:menu_id) { menu.id }

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

  describe 'nested menu items' do
    describe 'GET /api/menus/:menu_id/menu_items' do
      before { get "/api/menus/#{menu.id}/menu_items" }

      it 'returns all menu items for the given menu' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    describe 'GET /api/menus/:menu_id/menu_items/:id' do
        context 'when both menu and menu item exist' do
          before { get "/api/menus/#{menu_id}/menu_items/#{menu_item_id}" }
  
          it 'returns the menu item' do
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to include('name' => menu_items.first.name, 'price' => menu_items.first.price.to_f.to_s)
          end
        end
  
        context 'when the menu item does not exist' do
          before { get "/api/menus/#{menu_id}/menu_items/999" }
  
          it 'returns status not found' do
            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
          end
        end
    end

    describe 'PUT /api/menus/:menu_id/menu_items/:id' do
        let(:valid_attributes) { { menu_item: { name: 'French Toast' } } }

        context 'when both menu and menu item exist' do
          context 'with valid parameters' do
            before { put "/api/menus/#{menu_id}/menu_items/#{menu_item_id}", params: { menu_item: { name: 'French Toast' } } }
  
            it 'updates the menu item' do
              expect(response).to have_http_status(:ok)
              expect(JSON.parse(response.body)).to include('name' => 'French Toast')
            end
          end
  
          context 'with invalid parameters' do
            let(:invalid_attributes) { { menu_item: { name: nil } } }
            before { put "/api/menus/#{menu_id}/menu_items/#{menu_item_id}", params: invalid_attributes }
  
            it 'returns status unprocessable_entity' do
              expect(response).to have_http_status(:unprocessable_entity)
              expect(JSON.parse(response.body)).to have_key('errors')
            end
          end
        end
  
        context 'when the menu item does not exist' do
          before { put "/api/menus/#{menu_id}/menu_items/999", params: valid_attributes }
  
          it 'returns status not found' do
            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
          end
        end
    end

    describe 'POST /api/menus/:menu_id/menu_items' do
        let(:valid_attributes) { { menu_item: { name: 'Pancake', description: 'Delicious pancakes', price: 5.99, menu_id: menu.id } } }

        context 'when both menu and menu item exist' do
          before { post "/api/menus/#{menu.id}/menu_items", params: valid_attributes }
          
          it 'creates a new menu item' do
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to include('name' => 'Pancake', 'description' => 'Delicious pancakes', 'price' => '5.99')
          end
        end

        context 'when parameters are invalid' do
          let(:invalid_attributes) { { menu_item: { name: nil, price: 5.99 } } }
          
          before { post "/api/menus/#{menu.id}/menu_items", params: invalid_attributes }

          it 'returns unprocessable entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to have_key('errors')
          end
        end
    end

    describe 'DELETE /api/menus/:menu_id/menu_items/:id' do
        context 'when both menu and menu item exist' do
          before { delete "/api/menus/#{menu_id}/menu_items/#{menu_item_id}" }
          
          it 'deletes the menu item' do
            expect(response).to have_http_status(:no_content)
            expect(MenuItem.find_by(id: menu_item_id)).to be_nil
          end
        end

        context 'when the menu item does not exist' do
          before { delete "/api/menus/#{menu_id}/menu_items/999" }
          
          it 'returns status not found' do
            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to include('error' => 'Menu item not found')
          end
        end
    end
  end
end