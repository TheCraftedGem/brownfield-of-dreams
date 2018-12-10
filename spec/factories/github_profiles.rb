FactoryBot.define do
  factory :github_profile do
    uid { 123 }
    token { ENV["GITHUB_API_KEY"] }
    username {"MyString"}
    img_url { "https://a.wattpad.com/useravatar/johnnydeppyesplease.256.554848.jpg"}
    url {"MyString"}
    user
  end
end
