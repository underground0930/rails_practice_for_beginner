FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
