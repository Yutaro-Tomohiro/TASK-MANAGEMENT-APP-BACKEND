require 'rails_helper'

class TestController < ApplicationController
  include Authentication

  attr_accessor :cookies, :current_user

  def initialize
    super()
    @cookies = ActionDispatch::Request.new(Rails.application.env_config).cookie_jar
    @current_user = nil
  end
end

RSpec.describe Authentication, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JwtService.new.generate_jwt(user.identity) }
  let(:controller) { TestController.new }

  describe '#authenticate_user!' do
    context 'JWT が有効な場合' do
      before do
        controller.cookies.signed[:jwt] = token
      end

      it '正しく @current_user をセットする' do
        controller.send(:authenticate_user!)
        expect(controller.instance_variable_get(:@current_user)).to eq(user)
      end
    end

    context 'JWT が無効な場合' do
      before do
        controller.cookies.signed[:jwt] = nil
      end

      it 'UnauthorizedError を発生させる' do
        expect { controller.send(:authenticate_user!) }.to raise_error(UnauthorizedError)
      end
    end

    context 'JWT が期限切れの場合' do
      let(:freezed_time_token) do
        travel_to(Time.zone.local(2025, 1, 1)) { JwtService.new.generate_jwt(user.identity) }
      end

      before do
        controller.cookies.signed[:jwt] = freezed_time_token
      end

      it '期限切れのため UnauthorizedError を発生させる' do
        expect { controller.send(:authenticate_user!) }.to raise_error(UnauthorizedError)
      end
    end

    context 'JWT のフォーマットが不正な場合' do
      before do
        header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
        payload = 'eyJ1c2VyX2lkIjoiY2YxMjM0NTY3ODkwIiwiaWF0IjoxNjA5MTY4MTM3fQ'
        unsigned_invalid_token = header + '.' + payload + '.'

        controller.cookies.signed[:jwt] = unsigned_invalid_token
      end

      it 'デコードエラーのため UnauthorizedError を発生させる' do
        expect { controller.send(:authenticate_user!) }.to raise_error(UnauthorizedError)
      end
    end

    context 'JWT に含まれるユーザーが存在しない場合' do
      let(:invalid_token) { JwtService.new.generate_jwt('non_existing_user_id') }

      before do
        controller.cookies.signed[:jwt] = invalid_token
      end

      it '無効なユーザーのため UnauthorizedError を発生させる' do
        expect { controller.send(:authenticate_user!) }.to raise_error(UnauthorizedError)
      end
    end
  end
end
