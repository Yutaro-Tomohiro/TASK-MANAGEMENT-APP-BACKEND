require 'rails_helper'

RSpec.describe TaskRepository, type: :repository do
  let(:task_repository) { described_class.new }
  let(:users) { create_list(:user, 2) }
  let(:assignee_ids) { users.map(&:identity) }
  let(:task) { create(:task) }

  describe '#create' do
    context 'パラメータが有効な場合' do
      let(:result) {
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

      it 'User に紐づけられた Task が存在すること' do
        result.each do |user|
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
end
