FactoryBot.define do
  factory :question do
    title { "MyTitle" }
    body { "MyText" }
    association :author, factory: :user

    trait :with_answers do
      after :create do |question|
        create_list :answer, 3, :without_question, question: question
      end
    end
  end
end
