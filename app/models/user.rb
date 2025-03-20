# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  identity   :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_one :credential, dependent: :destroy
end
