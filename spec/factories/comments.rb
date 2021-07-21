FactoryBot.define do
  factory :comment do
    user
    association(:commentable, factory: :question)
    sequence(:body) { |n| "My coment #{n}" }
  end
end
