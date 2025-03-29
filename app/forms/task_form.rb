class TaskForm
  include ActiveModel::Model

  attr_accessor :identity

  validates :identity, presence: true
end
