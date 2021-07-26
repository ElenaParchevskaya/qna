FactoryBot.define do
  factory :authorization do
    user
    sequence(:provider) { |n| "Provider #{n}" }
    sequence(:uid) { |n| "uid#{n}" }
  end
end
