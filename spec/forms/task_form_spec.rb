require 'rails_helper'

RSpec.describe TaskForm, type: :model do
  let(:valid_attributes) do
    {
      assignee_ids: [ 'user_id_1', 'user_id_2' ],
      title: '新規タスク',
      priority: 'high',
      status: 'not_started',
      begins_at: Time.current,
      ends_at:  Time.current.advance(days: 2),
      text: 'タスク詳細'
    }
  end

  let(:task_form) { described_class.new(valid_attributes) }

  context 'バリデーションが正常な場合' do
    it '有効なフォームはバリデーションに通過する' do
      expect(task_form).to be_valid
    end
  end

  context 'title バリデーション' do
    it 'titleが空であれば無効' do
      task_form.title = nil
      expect(task_form).to be_invalid
    end
  end

  context 'priority バリデーション' do
    it 'priorityが空であれば無効' do
      task_form.priority = nil
      expect(task_form).to be_invalid
    end

    it '無効なpriorityの場合は無効' do
      task_form.priority = 'invalid_priority'
      expect(task_form).to be_invalid
    end

    it '有効なpriorityであれば有効' do
      task_form.priority = 'medium'
      expect(task_form).to be_valid
    end
  end

  context 'status バリデーション' do
    it 'statusが空であれば無効' do
      task_form.status = nil
      expect(task_form).to be_invalid
    end

    it '無効なstatusの場合は無効' do
      task_form.status = 'invalid_status'
      expect(task_form).to be_invalid
    end

    it '有効なstatusであれば有効' do
      task_form.status = 'in_progress'
      expect(task_form).to be_valid
    end
  end

  context 'begins_at と ends_at バリデーション' do
    it 'begins_atが空であれば無効' do
      task_form.begins_at = nil
      expect(task_form).to be_invalid
    end

    it 'ends_atが空であれば無効' do
      task_form.ends_at = nil
      expect(task_form).to be_invalid
    end

    it 'begins_atがends_atより後の場合は無効' do
      task_form.begins_at =  Time.current.advance(days: 3)
      task_form.ends_at =  Time.current.advance(days: 2)
      expect(task_form).to be_invalid
    end

    it 'begins_atがends_atより前の場合は有効' do
      task_form.begins_at = Time.current
      task_form.ends_at =  Time.current.advance(days: 2)
      expect(task_form).to be_valid
    end
  end

  context 'assignee_ids バリデーション' do
    it 'assignee_idsが空であれば無効' do
      task_form.assignee_ids = []
      expect(task_form).to be_invalid
    end

    it 'assignee_idsがArrayではない場合は無効' do
      task_form.assignee_ids = nil
      expect(task_form).to be_invalid
    end

    it 'assignee_idsがArrayであれば有効' do
      task_form.assignee_ids = [ 'user_id_1', 'user_id_2' ]
      expect(task_form).to be_valid
    end
  end

  context 'text バリデーション' do
    it 'textが空であれば無効' do
      task_form.text = nil
      expect(task_form).to be_invalid
    end
  end
end
