require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  describe "GET #show_content" do
    it "returns http success" do
      get :show_content
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show_peers" do
    it "returns http success" do
      get :show_peers
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show_discussion" do
    it "returns http success" do
      get :show_discussion
      expect(response).to have_http_status(:success)
    end
  end

end
