FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link #{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
  end
end
