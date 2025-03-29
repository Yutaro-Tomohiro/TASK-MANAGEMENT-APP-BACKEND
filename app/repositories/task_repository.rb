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

  def update(
    assignee_ids,
    title,
    priority,
    status,
    begins_at,
    ends_at,
    text = nil,
    identity
  )
    task = Task.find_by(identity: identity)

    raise NotFoundError.new unless task

    users = User.where(identity: assignee_ids)

    raise NotFoundError.new if users.empty?

    ActiveRecord::Base.transaction do
      task_identity = task.identity

      # タスクを削除してユーザーとの関連をリセット
      task.destroy

      # 新しいタスクを作成
      # TODO: create メソッドの処理と共通化する
      task = Task.create!(
        identity: task_identity,
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

  def delete(identity)
    task = Task.find_by(identity: identity)

    raise NotFoundError.new unless task

    task.destroy
  end

  def filter
    Task.all
  end
end
