FactoryBot.define do
  factory :answer do
    user
    question
    body { Faker::Lorem.sentence(word_count: 30) }
  end
end
