require 'rails_helper'

RSpec.feature "User Dashboard:", type: :feature do
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end
  context "Logged in user with a github-connected account"
    it 'can add ', :vcr do
      user = create(:user, active: true)
      github_profile_1 = create(:github_profile, user: user, uid: 16843426, token: ENV["GH_TOKEN_1"])
      page.driver.post(login_path, "session[email]" => user.email, "session[password]" => user.password)

      visit '/dashboard'

      fill_in "handle", with: "wfischer42"
      click_on "Send Invitation"

      expect(page).to have_content("Successfully sent invite!")
    end
  end
