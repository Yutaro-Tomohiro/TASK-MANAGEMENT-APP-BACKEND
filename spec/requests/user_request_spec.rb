require 'rails_helper'
RSpec.describe "Users API", type: :request do
  describe "POST /users" do
    let(:valid_attributes) do
      {
        name: "test_user",
        email: "test@example.com",
        password: "password123"
      }
    end

    context "リクエストが有効な時" do
      it "201 を返す" do
        post "/users", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(201)
      end
    end
  end
end
