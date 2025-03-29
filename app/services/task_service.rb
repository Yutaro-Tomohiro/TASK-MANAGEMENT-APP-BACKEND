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

  def update_task(request_body_form, path_params_form)
    raise BadRequestError.new unless request_body_form.valid?
    raise BadRequestError.new unless path_params_form.valid?

    @task_repository.update(
      request_body_form.assignee_ids,
      request_body_form.title,
      request_body_form.priority,
      request_body_form.status,
      request_body_form.begins_at,
      request_body_form.ends_at,
      request_body_form.text,
      path_params_form.identity
    )
  end

  def delete_task(form)
    raise BadRequestError.new unless form.valid?

    @task_repository.delete(form.identity)
  end

  def search_tasks(form)
    raise BadRequestError.new unless form.valid?

    @task_repository.filter(
      assignee_id: form.assignee_id,
      status: form.status,
      priority: form.priority,
      expires: form.expires,
      cursor: form.cursor
    )
  end
end
