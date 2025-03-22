require 'rails_helper'

RSpec.describe UserService, type: :service do
  let(:user_repository) { instance_double(UserRepository) }
  let(:user_service) { described_class.new(user_repository) }
  let(:user_form) { instance_double(UserRegistrationForm, name: "test_user", email: "test_user@example.com", password: "password123") }

  describe '#register_user' do
    context 'ユーザー登録が正常に行われる場合' do
      it 'ユーザーの作成メソッドが呼ばれること' do
        allow(user_repository).to receive(:create)

        user_service.register_user(user_form)

        expect(user_repository).to have_received(:create).with("test_user", "test_user@example.com", "password123")
      end
    end
  end
end
