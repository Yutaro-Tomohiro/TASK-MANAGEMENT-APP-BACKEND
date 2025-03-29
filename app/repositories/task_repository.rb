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

  def filter(assignee_id = nil, status = nil, priority = nil, expires = nil, cursor = nil)
    tasks = Task.all

    if assignee_id
      tasks = tasks.joins(:user_tasks).joins(:users).where(users: { identity: assignee_id }).distinct
    end

    if status
      tasks = tasks.where(status: status)
    end

    if priority
      tasks = tasks.where(priority: priority)
    end

    if expires
      current_time = Time.current
      tasks = expires == 'lt' ? tasks.where(ends_at: ..current_time) : tasks.where(ends_at: current_time..)
    end

    paginated_tasks, pagination = apply_cursor_pagination(tasks, cursor)

    raise NotFoundError.new if tasks.empty?

    {
      tasks: paginated_tasks,
      pagination: pagination
    }
  end

  private

  def apply_cursor_pagination(tasks, cursor)
    per_page = 10
    offset_value = cursor.to_i if cursor.present?
    paginated_tasks = tasks.offset(offset_value).limit(per_page)

    next_cursor = offset_value ? (offset_value + per_page).to_s : per_page.to_s
    previous_cursor = offset_value && offset_value > 0 ? (offset_value - per_page).to_s : nil

    pagination = {
      next_cursor: paginated_tasks.count == per_page ? next_cursor : nil,
      previous_cursor: previous_cursor
    }

    [ paginated_tasks, pagination ]
  end
end
