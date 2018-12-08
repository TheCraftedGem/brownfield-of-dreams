require 'rails_helper'

# TODO: Create test to make sure multiple users with different github keys see the right information.

RSpec.feature "User dashboard:", type: :feature do
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end
  context 'Signed in user visiting the dasboard', :vcr do
    it 'shows correct data for each user' do
      users = create_list(:user, 2)
      key = create(:github_profile, user: users[0], token: ENV["GH_TOKEN_1"])
      key = create(:github_profile, user: users[1], token: ENV["GH_TOKEN_2"])

      page.driver.post(login_path, "session[email]" => users[0].email, "session[password]" => users[0].password)

      visit dashboard_path
      expect(page).to have_content('BabyHughee')

      page.driver.delete(logout_path)
      page.driver.post(login_path, "session[email]" => users[1].email, "session[password]" => users[1].password)

      visit dashboard_path
    end

    it 'can see github followers', :vcr do

      followers = File.open("./spec/fixtures/followers.json")
      stub_request(:get, "https://api.github.com/user/followers")
        .to_return({body: followers})

      user = create(:user)
      key = create(:github_profile, user: user)

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)

      within("#github_followers") do
        expect(page).to have_link("averimj", href: "https://github.com/averimj")
      end
    end

    it "can see github repos", :vcr do
      repos = File.open("./spec/fixtures/repos.json")
      stub_request(:get, "https://api.github.com/user/repos")
        .to_return({body: repos})

      user = create(:user)
      key = create(:github_profile, user: user)

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)
      within '#github_repos' do
        expect(page).to have_link("2win_playlist", href: "https://github.com/wfischer42/2win_playlist")
      end
    end

    it "can see github following", :vcr do
      repos = File.open("./spec/fixtures/following.json")
      stub_request(:get, "https://api.github.com/user/following")
        .to_return({body: repos})

      user = create(:user)
      key = create(:github_profile, user: user)

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)
      within '#github_following' do
        expect(page).to have_link("moxie0", href: "https://github.com/moxie0")
      end
    end

    it "can log in with oauth", :vcr do 

      users = create_list(:user, 2) 

      visit '/dashboard'
      expect(page).to have_button("Connect on GitHub")

      click_button "Connect to Github"
    
      expect(current_page).to not_have_button("Connect on Github")
      


  end
end
