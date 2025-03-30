require 'rails_helper'

RSpec.describe "V1::Tasks API", type: :request do
  let(:user) { User.create!(identity: SecureRandom.uuid, name: "Test User") }
  let(:task) { create(:task) }
  let(:jwt_token) { JwtService.new.generate_jwt(user.identity) }  # 実際のJWTトークンを生成
  let(:valid_attributes) do
    {
      assignee_ids: [ user.identity ],
      title: "テストタスク",
      priority: "high",
      status: "not_started",
      begins_at: Time.current,
      ends_at: Time.current.advance(days: 1),
      text: "タスク詳細"
    }
  end
  let(:invalid_attributes) do
    {
      assignee_ids: [],
      title: "",
      priority: "",
      status: "",
      begins_at: nil,
      ends_at: nil
    }
  end

  before do
    cookies[:jwt] = jwt_token
    allow(JwtService).to receive(:decode_jwt).with(jwt_token).and_return([ { 'user_id' => user.identity } ])
    allow(User).to receive(:find_by).with(identity: user.identity).and_return(user)
    allow_any_instance_of(V1::TasksController).to receive(:authenticate_user!).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

  shared_examples "認証エラー" do
    it "401 を返す" do
      allow_any_instance_of(V1::TasksController).to receive(:authenticate_user!).and_raise(UnauthorizedError) # rubocop:disable RSpec/AnyInstance
      request_call
      expect(response).to have_http_status(401)
    end
  end

  shared_examples "サーバーエラー" do
    it "500 を返す" do
      allow(TaskRepository).to receive(:new).and_raise(StandardError.new("Internal Server Error"))
      request_call
      expect(response).to have_http_status(500)
    end
  end

  describe "POST /v1/tasks" do
    let(:request_call) { post "/v1/tasks", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" } }

    context "リクエストが有効な時" do
      it "201 を返す" do
        post "/v1/tasks", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(201)
      end
    end

    context "リクエストが無効な時" do
      it "400 を返す (必須フィールドが不足している場合)" do
        post "/v1/tasks", params: invalid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証エラーが発生した時" do
      it_behaves_like "認証エラー"
    end

    context "すべての assignee_ids が存在しないユーザー ID の時" do
      it "404 を返す" do
        invalid_user_id = SecureRandom.uuid

        post "/v1/tasks", params: valid_attributes.merge(assignee_ids: [ invalid_user_id ]).to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "サーバーエラーが発生した時" do
      it_behaves_like "サーバーエラー"
    end
  end

  describe "GET /v1/tasks/:id" do
    let(:request_call) { get "/v1/tasks/#{task.identity}", headers: { "CONTENT_TYPE" => "application/json" } }

    context "リクエストが有効な時" do
      it "200 を返す" do
        get "/v1/tasks/#{task.identity}", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(200)
      end
    end

    context "リクエストのidentityがUUIDでない時" do
      it "400 を返す" do
        get "/v1/tasks/invalid_task_id", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証エラーが発生した時" do
      it_behaves_like "認証エラー"
    end

    context "タスクが存在しない時" do
      it "404 を返す" do
        get "/v1/tasks/#{SecureRandom.uuid}", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "サーバーエラーが発生した時" do
      it_behaves_like "サーバーエラー"
    end
  end

  describe "PUT /v1/tasks/:id" do
    let(:request_call) { put "/v1/tasks/#{task.identity}", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" } }

    context "リクエストが有効な時" do
      it "204 を返す" do
        put "/v1/tasks/#{task.identity}", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(204)
      end
    end

    context "リクエストのidentityがUUIDでない時" do
      it "400 を返す" do
        put "/v1/tasks/invalid_task_id", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証エラーが発生した時" do
      it_behaves_like "認証エラー"
    end

    context "タスクが存在しない時" do
      it "404 を返す" do
        put "/v1/tasks/#{SecureRandom.uuid}", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "すべての assignee_ids が存在しないユーザー ID の時" do
      it "404 を返す" do
        put "/v1/tasks/#{task.identity}", params: valid_attributes.merge(assignee_ids: [ SecureRandom.uuid ]).to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "サーバーエラーが発生した時" do
      it_behaves_like "サーバーエラー"
    end
  end

  describe "DELETE /v1/tasks/:id" do
    let(:request_call) { delete "/v1/tasks/#{task.identity}", headers: { "CONTENT_TYPE" => "application/json" } }

    context "リクエストが有効な時" do
      it "204 を返す" do
        delete "/v1/tasks/#{task.identity}", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(204)
      end
    end

    context "リクエストのidentityがUUIDでない時" do
      it "400 を返す" do
        delete "/v1/tasks/invalid_task_id", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証エラーが発生した時" do
      it_behaves_like "認証エラー"
    end

    context "タスクが存在しない時" do
      it "404 を返す" do
        delete "/v1/tasks/#{SecureRandom.uuid}", headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "サーバーエラーが発生した時" do
      it_behaves_like "サーバーエラー"
    end
  end

  describe "GET /v1/tasks" do
    let(:valid_attributes) do
      {
        assignee_id: nil,
        status: nil,
        priority: nil,
        expires: nil,
        cursor: nil
      }
    end

    let(:invalid_attributes) do
      {
        assignee_id: 'invalid_assignee_id',
        status: 'invalid_status',
        priority: 'invalid_priority',
        expires: 'invalid_expires',
        cursor: 'invalid_cursor'
      }
    end

    let(:request_call) { get "/v1/tasks", params: valid_attributes, headers: { "CONTENT_TYPE" => "application/json" } }

    context "リクエストが有効な時" do
      it "200 を返す" do
        request_call
        expect(response).to have_http_status(200)
      end
    end

    context "リクエストが無効な時" do
      it "400 を返す" do
        get "/v1/tasks", params: invalid_attributes, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(400)
      end
    end

    context "認証エラーが発生した時" do
      it_behaves_like "認証エラー"
    end

    context "サーバーエラーが発生した時" do
      it_behaves_like "サーバーエラー"
    end
  end
end
