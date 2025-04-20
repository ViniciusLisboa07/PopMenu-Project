require 'rails_helper'

RSpec.describe "Api::ImportsController", type: :request do
  let(:valid_json) do
    {
      restaurants: [
        {
          name: "Poppo's Cafe",
          menus: [
            {
              name: "lunch",
              menu_items: [
                { name: "Burger", price: 9.00 },
                { name: "Small Salad", price: 5.00 }
              ]
            }
          ]
        }
      ]
    }.to_json
  end

  let(:invalid_json) { "{ invalid: json }" }
  let(:empty_json) { { restaurants: [] }.to_json }

  describe 'POST /api/import' do
    context 'with valid JSON' do
      before { post '/api/import', params: valid_json, headers: { 'CONTENT_TYPE' => 'application/json' } }

      it 'returns success status and logs' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('success')
        expect(JSON.parse(response.body)['logs']).to include(
          "Restaurant 'Poppo's Cafe' created or found successfully",
          "Menu 'lunch' created or found for restaurant 'Poppo's Cafe'",
          "Processing MenuItem 'Burger' (index 0) for menu 'lunch'",
          "Menu item 'Burger' created with price 9.0",
          "MenuItem 'Burger' associated with menu 'lunch'",
          "Processing MenuItem 'Small Salad' (index 1) for menu 'lunch'",
          "Menu item 'Small Salad' created with price 5.0",
          "MenuItem 'Small Salad' associated with menu 'lunch'"
        )
        expect(Restaurant.find_by(name: "Poppo's Cafe")).to be_present
        expect(MenuItem.find_by(name: "Burger")).to be_present
      end
    end

    context 'with invalid JSON' do
      before { post '/api/import', params: invalid_json, headers: { 'CONTENT_TYPE' => 'application/json' } }

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Invalid JSON')
      end
    end

    context 'with empty restaurants array' do
      before { post '/api/import', params: empty_json, headers: { 'CONTENT_TYPE' => 'application/json' } }

      it 'returns success with empty logs' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('success')
        expect(JSON.parse(response.body)['logs']).to be_empty
      end
    end
  end
end