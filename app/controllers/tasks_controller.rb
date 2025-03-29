class TasksController < ApplicationController
  include Authentication

  skip_before_action :verify_authenticity_token, only: [ :create ]

  def create
    form = TaskCreateForm.new(create_params)
    TaskService.new(TaskRepository.new).create_task(form)
    head :created
  end

  private

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
end
