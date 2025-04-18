require 'rails_helper'

RSpec.describe "Api::Menus", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/menu/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/menu/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/menu/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/menu/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/menu/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
