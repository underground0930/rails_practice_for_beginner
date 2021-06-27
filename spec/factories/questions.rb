FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    body { Faker::Lorem.sentence(word_count: 50) }
    solved { false }
    user
  end
end
