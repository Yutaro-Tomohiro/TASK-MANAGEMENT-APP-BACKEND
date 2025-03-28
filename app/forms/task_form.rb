class TaskForm
  include ActiveModel::Model

  attr_accessor :assignee_ids, :title, :priority, :status, :begins_at, :ends_at, :text

  validates :title, presence: true
  validates :priority, presence: true, inclusion: { in: [ 'low', 'medium', 'high' ] }
  validates :status, presence: true, inclusion: { in: [ 'not_started', 'in_progress', 'completed' ] }
  validates :begins_at, presence: true
  validates :ends_at, presence: true, if: :begins_at_before_ends_at?
  validates :text, presence: true

  validates :assignee_ids, presence: true, if: :assignee_ids_present?

  private

  def assignee_ids_present?
    assignee_ids.is_a?(Array) && assignee_ids.any?
  end

  def begins_at_before_ends_at?
    begins_at < ends_at ? true : false
  end
end
