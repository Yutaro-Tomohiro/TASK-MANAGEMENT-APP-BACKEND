class TaskService
  include TaskServiceInterface

  def initialize(task_repository)
    @task_repository = task_repository
  end

  def create_task(form)
    raise BadRequestError.new unless form.valid?

    @task_repository.create(
      form.assignee_ids,
      form.title,
      form.priority,
      form.status,
      form.begins_at,
      form.ends_at,
      form.text
    )
  end

  def find_task(form)
    raise BadRequestError.new unless form.valid?

    @task_repository.find(form.identity)
  end
end
