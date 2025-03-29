require 'rails_helper'

RSpec.describe TaskRepository, type: :repository do
  let(:task_repository) { described_class.new }
  let(:users) { create_list(:user, 2) }
  let(:assignee_ids) { users.map(&:identity) }
  let(:task) { create(:task) }
  let(:created_result) {
    task_repository.create(
      assignee_ids,
      task.title,
      task.priority,
      task.status,
      task.begins_at,
      task.ends_at,
      task.text
    )
  }

  describe '#create' do
    context 'パラメータが有効な場合' do
      let(:expected_attributes) do
        {
          title: task.title,
          priority: task.priority,
          status: task.status,
          begins_at: task.begins_at,
          ends_at: task.ends_at,
          text: task.text
        }
      end

      it '同じ Task に複数の User が紐づけられること' do
        expect(created_result.map(&:identity)).to match_array(assignee_ids)
      end

      it '正しい属性の Task が作成されること' do
        created_result.each do |user|
          expect(user.tasks).to all(have_attributes(expected_attributes))
        end
      end
    end

    context 'assignee_ids に該当するユーザーがいない場合' do
      let(:invalid_assignee_ids) { [ 'non_existent_id' ] }
      let(:arguments) do
        [
          invalid_assignee_ids,
          task.title,
          task.priority,
          task.status,
          task.begins_at,
          task.ends_at,
          task.text
        ]
      end

       it 'NotFoundError を発生させること' do
        expect { task_repository.create(*arguments) }.to raise_error(NotFoundError)
       end
    end
  end

  describe '#find' do
    context '指定された identity のタスクが存在する場合' do
      it 'タスクを返すこと' do
        expect(task_repository.find(task.identity)).to eq(task)
      end
    end

    context '指定された identity のタスクが存在しない場合' do
      it 'NotFoundError を発生させること' do
        expect { task_repository.find('non_existent_id') }.to raise_error(NotFoundError)
      end
    end
  end

  describe '#update' do
    let(:task_identity) { created_result.first.tasks.first.identity }

    context 'パラメータが有効な場合' do
      let(:updated_result) do
        task_repository.update(
          assignee_ids,
          'タイトルの更新',
          task.priority,
          task.status,
          task.begins_at,
          task.ends_at,
          task.text,
          task_identity
        )
      end

      it 'タスクを更新すること' do
        created_task = created_result.first.tasks.first.title
        updated_task = updated_result.first.tasks.first.title
        expect(updated_task).not_to eq(created_task)
      end
    end

    context '存在しないユーザーのみを指定した場合' do
      let(:invalid_assignee_ids) { [ 'non_existent_id' ] }
      let(:not_found_error_result) do
        task_repository.update(
          'non_existent_id',
          'タイトルの更新',
          task.priority,
          task.status,
          task.begins_at,
          task.ends_at,
          task.text,
          task_identity
        )
      end

      it 'NotFoundError を発生させること' do
        expect { not_found_error_result }.to raise_error(NotFoundError)
      end
    end

    context '存在しないタスクを更新した場合' do
      let(:invalid_task_identity) { 'non_existent_id' }
      let(:not_found_error_result) do
        task_repository.update(
          assignee_ids,
          'タイトルの更新',
          task.priority,
          task.status,
          task.begins_at,
          task.ends_at,
          task.text,
          invalid_task_identity
        )
      end

      it 'NotFoundError を発生させること' do
        expect { not_found_error_result }.to raise_error(NotFoundError)
      end
    end
  end

  describe '#delete' do
    context '指定された identity のタスクが存在する場合' do
      before { task }

      it 'タスクを削除すること' do
        expect { task_repository.delete(task.identity) }.to change(Task, :count).by(-1)
      end
    end

    context '指定された identity のタスクが存在しない場合' do
      it 'NotFoundError を発生させること' do
        expect { task_repository.delete('non_existent_id') }.to raise_error(NotFoundError)
      end
    end
  end

  describe '#filter' do
    let!(:first_user) { create(:user, identity: 'user_1', name: 'Alice') }
    let!(:second_user) { create(:user, identity: 'user_2', name: 'Bob') }
    let!(:first_task) { create(:task, identity: 'task_1', title: 'Task 1', text: 'Description of Task 1', status: 'not_started', priority: 'low', begins_at: Time.zone.now, ends_at: 1.day.from_now) }
    let!(:second_task) { create(:task, identity: 'task_2', title: 'Task 2', text: 'Description of Task 2', status: 'in_progress', priority: 'medium', begins_at: Time.zone.now, ends_at: 3.days.from_now) }

    before do
      first_user.tasks << first_task
      second_user.tasks << second_task
    end

    context 'パラメータに何も指定されていない時' do
      it '全てのタスクを返すこと' do
        expect(task_repository.filter[:tasks].map(&:identity)).to contain_exactly(first_task.identity, second_task.identity)
      end
    end

    context 'パラメータに assignee_id が指定されている時' do
      it '指定されたユーザーのタスクを返すこと' do
        result = task_repository.filter(assignee_id: first_user.identity)

        expect(result[:tasks].to_a).to contain_exactly(first_task)
      end
    end

    context 'パラメータに status が指定されている時' do
      it '指定されたステータスのタスクを返すこと' do
        result = task_repository.filter(status: 'not_started')
        expect(result[:tasks].to_a).to contain_exactly(first_task)
      end
    end

    context 'パラメータに priority が指定されている時' do
      it '指定された優先度のタスクを返すこと' do
        result = task_repository.filter(priority: 'low')
        expect(result[:tasks].to_a).to contain_exactly(first_task)
      end
    end

    context 'expires パラメータに lt が指定されている時' do
      it '期限切れのタスクを返すこと' do
        travel_to 2.days.from_now do
          result = task_repository.filter(expires: 'lt')
          expect(result[:tasks].to_a).to contain_exactly(first_task)
        end
      end
    end

    context 'expires パラメータに gt が指定されている時' do
      it '期限内のタスクを返すこと' do
        travel_to 2.days.from_now do
          result = task_repository.filter(expires: 'gt')
          expect(result[:tasks].to_a).to contain_exactly(second_task)
        end
      end
    end

    context 'カーソルベースのページネーションのテスト' do
      let(:many_users) do
        Array.new(20) do |i|
          create(:user, identity: "user_#{i}", name: "User #{i}")
        end
      end

      let(:many_tasks) do
        Array.new(20) do |i|
          create(:task, identity: "task_#{i}", title: "Task #{i}", text: "Description of Task #{i}", status: 'not_started', priority: 'low', begins_at: Time.zone.now, ends_at: 1.day.from_now)
        end
      end

      before do
        many_users.each do |user|
          user.tasks << many_tasks
        end
      end

      it 'カーソルが指定されていない場合、最初のページを返すこと' do
        result = task_repository.filter()
        expect(result[:pagination][:previous_cursor]).to be_nil
      end

      it 'カーソルが指定された場合、次のページのカーソルを返すこと' do
        result = task_repository.filter(cursor: 10)
        expect(result[:pagination][:next_cursor]).to eq('20')
      end

      it 'カーソルが指定された場合、前のページのカーソルを返すこと' do
        result = task_repository.filter(cursor: 20)
        expect(result[:pagination][:previous_cursor]).to eq('10')
      end

      it '最初のページの場合、前のページのカーソルが nil になること' do
        result = task_repository.filter(cursor: 0)
        expect(result[:pagination][:previous_cursor]).to be_nil
      end

      it '最後のページの場合、次のページのカーソル が nil になること' do
        result = task_repository.filter(cursor: 20)
        expect(result[:pagination][:next_cursor]).to be_nil
      end
    end

    context 'タスクが存在しない時' do
      it 'NotFoundError を発生させること' do
        first_task.destroy
        second_task.destroy
        expect { task_repository.filter }.to raise_error(NotFoundError)
      end
    end
  end
end
