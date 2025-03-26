require 'rails_helper'

RSpec.describe UserRepository, type: :repository do
  let(:user_repository) { described_class.new }
  let(:user) { create(:user) }

  describe '#create' do
    context 'パラメータが有効な場合' do
      let(:result_user) { user_repository.create(user.name, user.credential.email, user.credential.password) }

      it 'ユーザーが存在すること' do
        expect(result_user).to be_present
      end

      it 'ユーザーの名前が test_user であること' do
        expect(result_user.name).to eq(user.name)
      end

      it 'ユーザーの ID が存在すること' do
        expect(result_user.identity).to be_present
      end

      it 'ユーザーに認証情報が関連付けられること' do
        expect(result_user.credential).to be_present
      end

      it 'email が test_user@example.com であること' do
        expect(result_user.credential.email).to eq(user.credential.email)
      end

      it 'パスワードが password123 であること' do
        expect(result_user.credential.password).to eq(user.credential.password)
      end
    end
  end

  describe '#find_by_email' do
    context 'パラメータが有効な場合' do
      it '存在する email を検索すると正しいメールアドレスを持つ Credential を返すこと' do
        result_credential = user_repository.find_by_email(user.credential.email)
        expect(result_credential).to have_attributes(email: user.credential.email)
      end
    end

    context 'パラメータが無効な場合' do
      it '存在しない email を検索すると nil を返すこと' do
        result_credential = user_repository.find_by_email("non_existent@example.com")
        expect(result_credential).to be_nil
      end
    end
  end
end
