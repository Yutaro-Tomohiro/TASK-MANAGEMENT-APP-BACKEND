require 'rails_helper'

RSpec.describe TaskService, type: :service do
  let(:task_repository) { instance_double(TaskRepository) }
  let(:task_service) { described_class.new(task_repository) }
  let(:task) { create(:task) }
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
  let(:task_create_form) { instance_double(TaskCreateForm, arguments.merge(valid)) }
  let(:task_form) { instance_double(TaskForm, identity: task.identity) }

  describe '#create_task' do
    context 'タスクが正常に作成される場合' do
      it 'タスクの作成メソッドが呼ばれること' do
        allow(task_repository).to receive(:create)
        allow(task_create_form).to receive(:valid?).and_return(true)

        task_service.create_task(task_create_form)

        expect(task_repository).to have_received(:create).with(*arguments.values)
      end
    end

    context 'フォームが無効な場合' do
      before do
        allow(task_create_form).to receive(:valid?).and_return(false)
      end

      it 'BadRequestError を発生させること' do
        expect { task_service.create_task(task_create_form) }.to raise_error(BadRequestError)
      end
    end

    context 'assignee_ids に該当するユーザーがいない場合' do
      before do
        allow(task_create_form).to receive(:valid?).and_return(true)
        allow(task_repository).to receive(:create).and_raise(NotFoundError)
      end

      it 'NotFoundError を発生させること' do
        expect { task_service.create_task(task_create_form) }.to raise_error(NotFoundError)
      end
    end
  end

  describe '#find_task' do
    context 'タスクが存在する場合' do
      before do
        allow(task_repository).to receive(:find).with(task.identity).and_return(task)
        allow(task_form).to receive(:valid?).and_return(true)
      end

      it 'タスクを返すこと' do
        expect(task_service.find_task(task_form)).to eq(task)
      end
    end

    context 'フォームが無効な場合' do
      before do
        allow(task_form).to receive(:valid?).and_return(false)
      end

      it 'BadRequestError を発生させること' do
        expect { task_service.find_task(task_form) }.to raise_error(BadRequestError)
      end
    end

    context 'タスクが存在しない場合' do
      before do
        allow(task_repository).to receive(:find).with(task.identity).and_raise(NotFoundError)
        allow(task_form).to receive(:valid?).and_return(true)
      end

      it 'NotFoundError を発生させること' do
        expect { task_service.find_task(task_form) }.to raise_error(NotFoundError)
      end
    end
  end

  describe '#update_task' do
    let(:update_arguments) { arguments.merge(identity: task.identity) }

    context 'タスクが存在する場合' do
      it 'update_task メソッドが呼ばれること' do
        allow(task_repository).to receive(:update)
        allow(task_create_form).to receive(:valid?).and_return(true)
        allow(task_form).to receive(:valid?).and_return(true)

        task_service.update_task(task_create_form, task_form)

        expect(task_repository).to have_received(:update).with(*update_arguments.values)
      end
    end

    context 'リクエストボディフォームが無効な場合' do
      it 'BadRequestError を発生させること' do
        allow(task_create_form).to receive(:valid?).and_return(false)

        expect { task_service.update_task(task_create_form, **update_arguments) }.to raise_error(BadRequestError)
      end
    end

    context 'パスパラメータフォームが無効な場合' do
      it 'BadRequestError を発生させること' do
        allow(task_form).to receive(:valid?).and_return(false)

        expect { task_service.update_task(task_create_form, task_form) }.to raise_error(BadRequestError)
      end
    end
  end

  describe '#delete_task' do
    context 'タスクが存在する場合' do
      before do
        allow(task_repository).to receive(:delete).with(task.identity)
        allow(task_form).to receive(:valid?).and_return(true)
      end

      it 'delete_task メソッドが呼ばれること' do
        task_service.delete_task(task_form)
        expect(task_repository).to have_received(:delete).with(task.identity)
      end
    end

    context 'フォームが無効な場合' do
      before do
        allow(task_form).to receive(:valid?).and_return(false)
      end

      it 'BadRequestError を発生させること' do
        expect { task_service.delete_task(task_form) }.to raise_error(BadRequestError)
      end
    end
  end
end
