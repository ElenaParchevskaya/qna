FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.current }

    trait :with_question do
      after :create do |user|
        create :question, author: user
      end
    end

    trait :not_confirmed do
      confirmed_at { nil }
    end
  end
end
