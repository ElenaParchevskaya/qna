FactoryBot.define do
  factory :award do
    association :question, factory: :question
    sequence(:name) { |n| "Award name #{n}" }
    image { Rack::Test::UploadedFile.new('spec/fixtures/appwatch.jpeg', 'image/jpeg') }
  end
end
