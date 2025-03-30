class TaskForm
  include ActiveModel::Model

  attr_accessor :identity

  validates :identity, presence: true
  validates :identity, format: { with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i }
end
