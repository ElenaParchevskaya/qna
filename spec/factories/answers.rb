FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }

    association :question, factory: :question
    association :author, factory: :user
  end

  trait :without_question do
    body { 'MyAnswer' }
  end

  trait :invalid do
    body { '' }
  end
end
