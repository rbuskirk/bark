FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    email { "#{name}@dawgs.org" }
    password { "password" }
  end
end
