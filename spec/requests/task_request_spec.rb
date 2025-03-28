require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let(:user) { User.create!(identity: SecureRandom.uuid, name: "Test User") }
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
    allow_any_instance_of(TasksController).to receive(:authenticate_user!).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

  describe "POST /tasks" do
    context "リクエストが有効な時" do
      it "201 を返す" do
        post "/tasks", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(201)
      end
    end

    context "リクエストが無効な時" do
      it "400 を返す (必須フィールドが不足している場合)" do
        post "/tasks", params: invalid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(400)
      end
    end

    context "認証エラー" do
      it "401 を返す" do
        allow_any_instance_of(TasksController).to receive(:authenticate_user!).and_raise(UnauthorizedError) # rubocop:disable RSpec/AnyInstance
        post "/tasks", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(401)
      end
    end

    context "assignee_ids に存在しないユーザーIDが含まれている時" do
      it "404 を返す" do
        invalid_user_id = SecureRandom.uuid

        post "/tasks", params: valid_attributes.merge(assignee_ids: [ invalid_user_id ]).to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(404)
      end
    end

    context "サーバーエラーが発生した時" do
      it "500 を返す" do
        task_service = instance_double(TaskRepository)
        allow(task_service).to receive(:create).and_raise(StandardError.new("Internal Server Error"))

        allow(TaskRepository).to receive(:new).and_return(task_service)

        post "/tasks", params: valid_attributes.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response).to have_http_status(500)
      end
    end
  end
end
