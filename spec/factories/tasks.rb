FactoryBot.define do
  factory :task do
    identity { SecureRandom.uuid }
    sequence(:title) { |n| "テストタスク #{n}" }
    text { "テストタスクの詳細" }
    priority { :medium }
    status { :not_started }
    begins_at { Time.zone.now }
    ends_at { Time.current.advance(days: 1) }

    trait :high_priority do
      priority { :high }
    end

    trait :completed do
      status { :completed }
    end

    trait :urgent do
      priority { :high }
      status { :in_progress }
      begins_at { Time.zone.now }
      ends_at { Time.current.advance(hours: 6) }
    end
  end
end
