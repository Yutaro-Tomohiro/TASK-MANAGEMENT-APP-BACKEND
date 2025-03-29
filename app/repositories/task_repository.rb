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
    ActiveRecord::Base.transaction do
      users = User.where(identity: assignee_ids)

      raise NotFoundError.new if users.empty?

      users.each do |user|
        UserTask.create!(
          user: user,
          task: Task.create!(
            identity: SecureRandom.uuid,
            title: title,
            priority: priority,
            status: status,
            begins_at: begins_at,
            ends_at: ends_at,
            text: text
          )
        )
      end
    end
  end

  def find(identity)
    Task.find_by(identity: identity)
  end
end
