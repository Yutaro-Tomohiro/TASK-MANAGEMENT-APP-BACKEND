# == Schema Information
#
# Table name: user_tasks
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  task_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_tasks_on_task_id  (task_id)
#  index_user_tasks_on_user_id  (user_id)
#

class UserTask < ApplicationRecord
  belongs_to :user
  belongs_to :task
end
