class Task < ApplicationRecord
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

  enum :priority, { low: 0, medium: 1, high: 2 }, prefix: true
  enum :status, { not_started: 0, in_progress: 1, completed: 2 }, prefix: true

  validates :identity, presence: true
  validates :title, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end
