FactoryBot.define do
  factory :api_key do
    user_id 1
    key { ENV["GITHUB_API_KEY"] }
    source { :github }
    association :user, factory: :user
  end
end
