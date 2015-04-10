require 'rails_helper'

RSpec.describe UserDetailsController, type: :controller do

  describe "GET #uploads" do
    it "returns http success" do
      get :uploads
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #downloads" do
    it "returns http success" do
      get :downloads
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #profile" do
    it "returns http success" do
      get :profile
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #enrolled_courses" do
    it "returns http success" do
      get :enrolled_courses
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #favorite_courses" do
    it "returns http success" do
      get :favorite_courses
      expect(response).to have_http_status(:success)
    end
  end

end
