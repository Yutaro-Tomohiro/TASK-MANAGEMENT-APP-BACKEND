# == Schema Information
#
# Table name: credentials
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  password   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Credential < ApplicationRecord
  belongs_to :user
end
