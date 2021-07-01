FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
  end

  trait :without_question do
    body { 'MyText' }
  end

  trait :invalid do
    body { '' }
  end
end
