require 'rails_helper'

RSpec.describe UserAuthenticationService, type: :service do
  let(:user_repository) { instance_double(UserRepository) }
  let(:jwt_service) { instance_double(JwtService) }
  let(:user) { create(:user) }
  let(:user_authentication_service) { described_class.new(user_repository, jwt_service) }
  let(:form) { instance_double(UserLoginForm, email: user.credential.email, password: user.credential.password) }

  describe '#login_user' do
    context 'フォームが有効な場合' do
      before do
        allow(form).to receive(:valid?).and_return(true)
        allow(user_repository).to receive(:authenticate_user).and_return(user)
        allow(jwt_service).to receive(:generate_jwt).with(user.identity).and_return('mocked_jwt_token')
      end

      let(:result) { user_authentication_service.login_user(form) }

      it 'ユーザーが認証されること' do
        expect(result[:user]).to eq(user)
      end

      it 'JWT トークンが生成されること' do
        expect(result[:token]).to eq('mocked_jwt_token')
      end
    end

    context 'フォームが無効な場合' do
      before do
        allow(form).to receive(:valid?).and_return(false)
      end

      it 'BadRequestError を発生させること' do
        expect { user_authentication_service.login_user(form) }.to raise_error(BadRequestError)
      end
    end

    context 'ユーザー認証に失敗した場合' do
      before do
        allow(form).to receive(:valid?).and_return(true)
        allow(user_repository).to receive(:authenticate_user).and_return(nil)
      end

      it 'UnauthorizedError を発生させること' do
        expect { user_authentication_service.login_user(form) }.to raise_error(UnauthorizedError)
      end
    end
  end
end
