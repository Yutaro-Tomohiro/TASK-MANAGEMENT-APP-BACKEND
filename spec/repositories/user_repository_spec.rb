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

  describe '#find_by_email' do
    let!(:user) { create(:user, name: "test_user") }
    let!(:credential) { create(:credential, user: user, email: "test_user@example.com", password: "password123") }

    context 'パラメータが有効な場合' do
      it '存在する email を検索すると Credential を返すこと' do
        result = user_repository.find_by_email("test_user@example.com")
        expect(result).to have_attributes(email: credential.email, password: credential.password)
      end
    end

    context 'パラメータが無効な場合' do
      it '存在しない email を検索すると nil を返すこと' do
        result = user_repository.find_by_email("non_existent@example.com")
        expect(result).to be_nil
      end
    end
  end
end
