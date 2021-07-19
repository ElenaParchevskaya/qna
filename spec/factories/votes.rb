FactoryBot.define do
  factory :vote do
    user
    association(:votable, factory: :question)

    trait :like do
      status { 1 }
    end

    trait :dislike do
      status { -1 }
    end
  end
end
