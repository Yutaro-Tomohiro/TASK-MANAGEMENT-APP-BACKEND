class TaskRepository
  include TaskRepositoryInterface

  def create(
    assignee_ids,
    title,
    priority,
    status,
    begins_at,
    ends_at,
    text = nil
  )
    users = User.where(identity: assignee_ids)

    raise NotFoundError.new if users.empty?

    ActiveRecord::Base.transaction do
      task = Task.create!(
        identity: SecureRandom.uuid,
        title: title,
        priority: priority,
        status: status,
        begins_at: begins_at,
        ends_at: ends_at,
        text: text
      )

      users.each do |user|
        UserTask.create!(
          user: user,
          task: task
        )
      end
    end
  end

  def find(identity)
    task = Task.find_by(identity: identity)

    raise NotFoundError.new unless task

    task
  end

  def delete(identity)
    task = Task.find_by(identity: identity)

    raise NotFoundError.new unless task

    task.destroy
  end
end
