class TaskForm
  include ActiveModel::Model

  attr_accessor :assignee_ids, :title, :priority, :status, :begins_at, :ends_at, :text

  validates :title, presence: true
  validates :priority, presence: true, inclusion: { in: [ 'low', 'medium', 'high' ] }
  validates :status, presence: true, inclusion: { in: [ 'not_started', 'in_progress', 'completed' ] }
  validates :begins_at, presence: true
  validates :ends_at, presence: true
  validates :text, presence: true

  validate :assignee_ids_present
  validate :assignee_ids_is_array
  validate :begins_at_before_ends_at

  private

  def assignee_ids_present
    errors.add(:assignee_ids) if assignee_ids.blank?
  end

  def assignee_ids_is_array
    errors.add(:assignee_ids) unless assignee_ids.is_a?(Array)
  end

  def begins_at_before_ends_at
    if begins_at.present? && ends_at.present? && begins_at >= ends_at
      errors.add(:begins_at, :ends_at)
    end
  end
end
