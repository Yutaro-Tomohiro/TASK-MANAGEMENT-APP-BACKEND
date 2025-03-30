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

FactoryBot.define do
  factory :user do
    identity { SecureRandom.uuid }
    name { "test_user" }

    after(:create) do |user|
      create(:credential, user: user)
    end
  end
end
