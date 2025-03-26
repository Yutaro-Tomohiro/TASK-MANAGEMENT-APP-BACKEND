class TaskForm
  include ActiveModel::Model

  attr_accessor :assignee_ids, :title, :priority, :status, :begins_at, :ends_at, :text
end
