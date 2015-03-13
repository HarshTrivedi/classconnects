require 'rails_helper'

RSpec.describe FoldersController, type: :controller do

  describe "GET #show_content" do
    it "returns http success" do
      get :show_content
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show_details" do
    it "returns http success" do
      get :show_details
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit_details" do
    it "returns http success" do
      get :edit_details
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update_details" do
    it "returns http success" do
      get :update_details
      expect(response).to have_http_status(:success)
    end
  end

end
