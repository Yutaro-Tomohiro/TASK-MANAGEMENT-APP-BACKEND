FactoryBot.define do
  factory :user do
    identity { SecureRandom.uuid }
    name { "test_user" }

    after(:create) do |user|
      create(:credential, user: user)
    end
  end
end
