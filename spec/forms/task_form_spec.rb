require 'rails_helper'

RSpec.describe TaskForm, type: :model do
  let(:task) { create(:task) }
  let(:valid_attributes) { { identity: task.identity } }

  let(:task_form) { described_class.new(valid_attributes) }

  context 'バリデーションが正常な場合' do
    it '有効なフォームはバリデーションに通過する' do
      expect(task_form).to be_valid
    end
  end

  context 'バリデーションが異常な場合' do
    it 'identityが空の場合は無効' do
      task_form.identity = nil
      expect(task_form).to be_invalid
    end

    it 'identityがUUIDでない場合は無効' do
      task_form.identity = 'invalid_uuid'
      expect(task_form).to be_invalid
    end
  end
end
