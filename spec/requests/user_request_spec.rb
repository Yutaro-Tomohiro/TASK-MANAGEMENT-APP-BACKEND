require 'rails_helper'
RSpec.describe "V1::Users API", type: :request do
  describe "POST /v1/users" do
    let(:valid_attributes) do
      {
        name: "test_user",
        email: "test@example.com",
        password: "password123"
      }
    end

    let(:invalid_attributes) { { name: "", email: "invalid-email", password: "short" } }

    context "リクエストが有効な時" do
      it "201 を返す" do
        post "/v1/users", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(201)
      end
    end

    context "リクエストが無効な時" do
      it "400 を返す" do
        post "/v1/users", params: invalid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "登録済みの email の時" do
      it "409 を返す" do
        post "/v1/users", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }
        post "/v1/users", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(409)
      end
    end

    context "サーバーエラーが発生した時" do
      it '500 を返す' do
        user_service = instance_double(UserService)
        allow(user_service).to receive(:register_user).and_raise(StandardError.new("Internal Server Error"))

        allow(UserService).to receive(:new).and_return(user_service)

        post '/v1/users', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
        expect(response).to have_http_status(500)
      end
    end
  end

  describe "POST /v1/users/login" do
    let(:create_user_attributes) do
      {
        name: "test_user",
        email: "test@example.com",
        password: "password123"
      }
    end

    let(:valid_login_attributes) do
      {
        email: "test@example.com",
        password: "password123"
      }
    end

    let(:invalid_login_attributes) do
      {
        email: "test@example.com",
        password: "wrongpassword"
      }
    end

    let(:missing_email_attributes) do
      {
        password: "password123"
      }
    end

    let(:missing_password_attributes) do
      {
        email: "test@example.com"
      }
    end

    before do
      post "/v1/users", params: create_user_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }
    end

    context "リクエストが有効な時" do
      it "200 を返す" do
        post "/v1/users/login", params: valid_login_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(200)
      end
    end

    context "フォームが無効な時" do
      it "400 を返す (パラメータが不足している場合)" do
        post "/v1/users/login", params: missing_email_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end

      it "400 を返す (パスワードが不足している場合)" do
        post "/v1/users/login", params: missing_password_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証が失敗した場合" do
      it "401 を返す (無効なメールアドレスまたはパスワード)" do
        post "/v1/users/login", params: invalid_login_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(401)
      end
    end

    context "サーバーエラーが発生した場合" do
      it "500 を返す" do
        user_authentication_service = instance_double(UserAuthenticationService)
        allow(user_authentication_service).to receive(:login_user).and_raise(StandardError.new("Internal Server Error"))

        allow(UserAuthenticationService).to receive(:new).and_return(user_authentication_service)

        post "/v1/users/login", params: valid_login_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(500)
      end
    end
  end
end
