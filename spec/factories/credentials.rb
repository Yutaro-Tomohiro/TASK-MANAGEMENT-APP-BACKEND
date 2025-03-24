FactoryBot.define do
  factory :credential do
    email { "test_user@example.com" }
    password { "password123" }
    user
  end
end
