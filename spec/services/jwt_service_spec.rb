require 'rails_helper'

RSpec.describe JwtService, type: :service do
  let(:jwt_service) { described_class.new }
  let(:user_id) { create(:user).identity }
  let(:secret_key) { Rails.application.credentials.secret_key_base }
  let(:algorithm) { 'HS256' }
  let(:fixed_time) { Time.zone.now }

  describe '#generate_jwt' do
    context '正常系' do
      let(:token) { jwt_service.generate_jwt(user_id) }
      let(:payload) { JWT.decode(token, secret_key, true, { algorithm: algorithm }).first }

      it 'JWT を生成すること' do
        expect(token).to be_a(String)
      end

      it 'JWT にユーザー ID が含まれていること' do
        expect(payload['user_id']).to eq(user_id)
      end

      it '有効期限が現在時刻より未来であること' do
        travel_to fixed_time do
          expect(payload['exp']).to be > fixed_time.to_i
        end
      end
    end
  end
end
