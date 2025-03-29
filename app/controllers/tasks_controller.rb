class TasksController < ApplicationController
  include Authentication

  skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]

  def show
    form = TaskForm.new(path_params)
    task = TaskService.new(TaskRepository.new).find_task(form)
    render json: task_json(task), status: :ok
  end

  def create
    form = TaskCreateForm.new(create_params)
    TaskService.new(TaskRepository.new).create_task(form)
    head :created
  end

  def destroy
    form = TaskForm.new(path_params)
    TaskService.new(TaskRepository.new).delete_task(form)
    head :no_content
  end

  private

  def path_params
    params.permit(:identity)
  end

  def create_params
    params.permit(
      :title,
      :priority,
      :status,
      :begins_at,
      :ends_at,
      :text,
      assignee_ids: []
    )
  end

  def task_json(task)
    {
      assignee_ids: task.users.map(&:identity),
      title: task.title,
      priority: task.priority,
      status: task.status,
      begins_at: task.begins_at,
      ends_at: task.ends_at,
      text: task.text
    }
  end
end
