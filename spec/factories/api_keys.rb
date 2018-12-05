FactoryBot.define do
  factory :api_key do
    key { ENV["GITHUB_API_KEY"] }
    source { :github }
    user { nil }
  end
end
