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

FactoryBot.define do
  factory :credential do
    email { "test_user@example.com" }
    password { "password123" }
    user
  end
end
