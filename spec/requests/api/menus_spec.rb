require 'rails_helper'

RSpec.describe "Api::MenusController", type: :request do
  let!(:menus) { create_list(:menu, 3) }
  let(:menu_id) { menus.first.id }

  describe 'GET /api/menus' do
    before { get '/api/menus' }

    it 'returns all menus' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/menus/:id' do
    context 'when the menu exists' do
      before { get "/api/menus/#{menu_id}" }

      it 'returns the menu' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(menu_id)
      end
    end

    context 'when the menu does not exist' do
      before { get "/api/menus/0" }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu not found')
      end
    end
  end

  describe 'POST /api/menus' do
    let(:valid_attributes) { { menu: { name: 'New Menu', description: 'Description of the new menu', active: true } } }
    let(:invalid_attributes) { { menu: { name: nil, description: 'Description of the new menu', active: true } } }

    context 'when the parameters are valid' do
      before { post '/api/menus', params: valid_attributes }

      it 'creates a new menu' do
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('New Menu')
      end
    end

    context 'when the parameters are invalid' do
      before { post '/api/menus', params: invalid_attributes }

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'PUT /api/menus/:id' do
    let(:valid_attributes) { { menu: { name: 'Menu Updated' } } }
    let(:invalid_attributes) { { menu: { name: nil } } }

    context 'when the menu exists' do
      context 'with valid parameters' do
        before { put "/api/menus/#{menu_id}", params: valid_attributes }

        it 'updates the menu' do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['name']).to eq('Menu Updated')
        end
      end

      context 'with invalid parameters' do
        before { put "/api/menus/#{menu_id}", params: invalid_attributes }

        it 'returns status unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('errors')
        end
      end
    end

    context 'when the menu does not exist' do
      before { put "/api/menus/0", params: valid_attributes }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu not found')
      end
    end
  end

  describe 'DELETE /api/menus/:id' do
    context 'when the menu exists' do
      before { delete "/api/menus/#{menu_id}" }

      it 'deletes the menu' do
        expect(response).to have_http_status(:no_content)
        expect(Menu.find_by(id: menu_id)).to be_nil
      end
    end

    context 'when the menu does not exist' do
      before { delete "/api/menus/0" }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Menu not found')
      end
    end
  end
end