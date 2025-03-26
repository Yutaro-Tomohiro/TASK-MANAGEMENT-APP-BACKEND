require 'rails_helper'

RSpec.describe UserLoginForm, type: :model do
  let(:valid_attributes) { { email: "test_user@example.com", password: "password123" } }
  let(:user_login_form) { described_class.new(valid_attributes) }

  context 'バリデーションが正常な場合' do
    it '有効なフォームはバリデーションに通過する' do
      expect(user_login_form).to be_valid
    end
  end

  context 'email バリデーション' do
    it 'emailが空であれば無効' do
      user_login_form.email = nil
      expect(user_login_form).to be_invalid
    end

    it '無効なフォーマットのemailであれば無効' do
      user_login_form.email = 'invalid_email'
      expect(user_login_form).to be_invalid
    end

    it '有効なemailであれば有効' do
      user_login_form.email = 'valid@example.com'
      expect(user_login_form).to be_valid
    end
  end

  context 'password バリデーション' do
    it 'passwordが空であれば無効' do
      user_login_form.password = nil
      expect(user_login_form).to be_invalid
    end

    it 'passwordが8文字未満であれば無効' do
      user_login_form.password = 'short'
      expect(user_login_form).to be_invalid
    end

    it 'passwordが24文字を超えると無効' do
      user_login_form.password = 'a' * 25
      expect(user_login_form).to be_invalid
    end

    it 'passwordが8〜24文字以内であれば有効' do
      user_login_form.password = 'validpassword123'
      expect(user_login_form).to be_valid
    end
  end
end
