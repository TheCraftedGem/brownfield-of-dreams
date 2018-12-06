FactoryBot.define do
  factory :github_profile do
    uid { 123 }
    token { ENV["GITHUB_API_KEY"] }
    username {"MyString"}
    img_url {"MyString"}
    url {"MyString"}
    user
  end
end
