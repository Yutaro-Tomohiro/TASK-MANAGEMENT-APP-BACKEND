require 'rails_helper'

RSpec.describe UserRepository, type: :repository do
  let(:user_repository) { described_class.new }
  let(:user) { create(:user) }
  let(:credential) { user.credential }

  describe '#create' do
    context 'パラメータが有効な場合' do
      it 'ユーザーが存在すること' do
        expect(user).to be_present
      end

      it 'ユーザーの名前が test_user であること' do
        expect(user.name).to eq("test_user")
      end

      it 'ユーザーの ID が存在すること' do
        expect(user.identity).to be_present
      end

      it 'ユーザーに認証情報が関連付けられること' do
        expect(user.credential).to be_present
      end

      it 'email が test_user@example.com であること' do
        expect(credential.email).to eq("test_user@example.com")
      end

      it 'パスワードが password123 であること' do
        expect(credential.password).to eq("password123")
      end
    end
  end
end
