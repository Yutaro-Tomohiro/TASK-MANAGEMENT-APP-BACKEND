class SearchTasksForm
  include ActiveModel::Model

  attr_accessor :assignee_id, :status, :priority, :expires, :cursor

  validates :assignee_id, allow_nil: true, format: { with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i }
  validates :status, allow_nil: true, inclusion: { in: [ 'not_started', 'in_progress', 'completed' ] }
  validates :priority, allow_nil: true, inclusion: { in: [ 'low', 'medium', 'high' ] }
  validates :expires, allow_nil: true, inclusion: { in: [ 'lt', 'gt' ] }
  validates :cursor, allow_nil: true, numericality: { only_integer: true }
end
