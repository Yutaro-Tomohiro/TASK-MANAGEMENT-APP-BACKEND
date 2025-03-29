require 'rails_helper'

RSpec.describe SearchTasksForm, type: :model do
  let(:task) { create(:task) }
  let(:valid_attributes) do
    {
      assignee_id: 'a4215ca5-b4e6-466c-80b7-f6371b9c6ffb',
      status: 'not_started',
      priority: 'low',
      expires: 'gt',
      cursor:  10
    }
  end

  let(:form) { described_class.new(valid_attributes) }

  context 'バリデーションが正常な場合' do
    it '有効なフォームはバリデーションに通過する' do
      expect(form).to be_valid
    end
  end

  context 'assignee_id バリデーション' do
    it 'UUID でない場合は無効' do
      valid_attributes[:assignee_id] = 'invalid_uuid'
      expect(form).to be_invalid
    end
  end

  context 'status バリデーション' do
    it '存在しない status の場合は無効' do
      valid_attributes[:status] = 'invalid_status'
      expect(form).to be_invalid
    end
  end

  context 'priority バリデーション' do
    it '存在しない priority の場合は無効' do
      valid_attributes[:priority] = 'invalid_priority'
      expect(form).to be_invalid
    end
  end

  context 'expires バリデーション' do
    it '存在しない expires の場合は無効' do
      valid_attributes[:expires] = 'invalid_expires'
      expect(form).to be_invalid
    end
  end

  context 'cursor バリデーション' do
    it '数値でない場合は無効' do
      valid_attributes[:cursor] = 'invalid_cursor'
      expect(form).to be_invalid
    end
  end
end
