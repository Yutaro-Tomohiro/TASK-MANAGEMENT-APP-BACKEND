require 'rails_helper'

RSpec.describe TaskService, type: :service do
  let(:task_repository) { instance_double(TaskRepository) }
  let(:task_service) { described_class.new(task_repository) }
  let(:first_user_id) { SecureRandom.uuid }
  let(:second_user_id) { SecureRandom.uuid }
  let(:arguments) do
    {
      assignee_ids: [ first_user_id, second_user_id ],
      title: "新規タスク",
      priority: "high",
      status: "not_started",
      begins_at: Time.current,
      ends_at:  Time.current.advance(days: 2),
      text: "タスク詳細"
    }
  end
  let(:valid) do
    { valid?: true }
  end
  let(:task_form) { instance_double(TaskCreateForm, arguments.merge(valid)) }

  describe '#create_task' do
    context 'タスクが正常に作成される場合' do
      it 'タスクの作成メソッドが呼ばれること' do
        allow(task_repository).to receive(:create)
        allow(task_form).to receive(:valid?).and_return(true)

        task_service.create_task(task_form)

        expect(task_repository).to have_received(:create).with(*arguments.values)
      end
    end

    context 'フォームが無効な場合' do
      before do
        allow(task_form).to receive(:valid?).and_return(false)
      end

      it 'BadRequestError を発生させること' do
        expect { task_service.create_task(task_form) }.to raise_error(BadRequestError)
      end
    end

    context 'assignee_ids に該当するユーザーがいない場合' do
      before do
        allow(task_form).to receive(:valid?).and_return(true)
        allow(task_repository).to receive(:create).and_raise(NotFoundError)
      end

      it 'NotFoundError を発生させること' do
        expect { task_service.create_task(task_form) }.to raise_error(NotFoundError)
      end
    end
  end
end
