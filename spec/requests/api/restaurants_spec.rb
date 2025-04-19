require 'rails_helper'

RSpec.describe "Api::RestaurantsController", type: :request do
  let!(:restaurant) { create(:restaurant, name: 'The Bistro') }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let(:valid_attributes) { { restaurant: { name: 'New Restaurant' } } }
  let(:invalid_attributes) { { restaurant: { name: nil } } }

  describe 'GET /api/restaurants' do
    before { get '/api/restaurants' }

    it 'returns all restaurants with their menus' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first).to include('name' => 'The Bistro')
    end
  end

  describe 'GET /api/restaurants/:id' do
    context 'when the restaurant exists' do
      before { get "/api/restaurants/#{restaurant.id}" }

      it 'returns the restaurant with its menus' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('name' => 'The Bistro', 'menus' => [a_hash_including('id' => menu.id)])
      end
    end

    context 'when the restaurant does not exist' do
      before { get '/api/restaurants/999' }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Restaurant not found')
      end
    end
  end

  describe 'POST /api/restaurants' do
    context 'with valid parameters' do
      before { post '/api/restaurants', params: valid_attributes }

      it 'creates a new restaurant' do
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('name' => 'New Restaurant')
      end
    end

    context 'with invalid parameters' do
      before { post '/api/restaurants', params: invalid_attributes }

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'PUT /api/restaurants/:id' do
    context 'with valid parameters' do
      before { put "/api/restaurants/#{restaurant.id}", params: { restaurant: { name: 'Updated Bistro' } } }

      it 'updates the restaurant' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('name' => 'Updated Bistro')
      end
    end

    context 'with invalid parameters' do
      before { put "/api/restaurants/#{restaurant.id}", params: invalid_attributes }

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'DELETE /api/restaurants/:id' do
    context 'when the restaurant exists' do
      before { delete "/api/restaurants/#{restaurant.id}" }

      it 'deletes the restaurant' do
        expect(response).to have_http_status(:no_content)
        expect(Restaurant.find_by(id: restaurant.id)).to be_nil
      end
    end

    context 'when the restaurant does not exist' do
      before { delete '/api/restaurants/999' }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Restaurant not found')
      end
    end
  end

  describe 'GET /api/restaurants/:restaurant_id/menus' do
    context 'when the restaurant exists' do
      before { get "/api/restaurants/#{restaurant.id}/menus" }

      it 'returns all menus for the restaurant' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body).first).to include('id' => menu.id)
      end
    end

    context 'when the restaurant does not exist' do
      before { get '/api/restaurants/0/menus' }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Restaurant not found')
      end
    end
  end

  describe 'POST /api/restaurants/:restaurant_id/menus' do
    let(:menu_attributes) { { menu: { name: 'Dinner', description: 'Evening meals', active: true } } }

    context 'when the restaurant exists' do
      before { post "/api/restaurants/#{restaurant.id}/menus", params: menu_attributes }

      it 'creates a new menu for the restaurant' do
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('name' => 'Dinner')
        expect(Menu.last.restaurant_id).to eq(restaurant.id)
      end
    end

    context 'when the restaurant does not exist' do
      before { post '/api/restaurants/999/menus', params: menu_attributes }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Restaurant not found')
      end
    end
  end
end