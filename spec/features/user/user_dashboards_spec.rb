require 'rails_helper'

# TODO: Create test to make sure multiple users with different github keys see the right information.

RSpec.feature "User dashboard:", type: :feature do
  context 'Signed in user visiting the dasboard' do
    it 'can see github followers', :vcr do

      followers = File.open("./spec/fixtures/followers.json")
      stub_request(:get, "https://api.github.com/user/followers")
        .to_return({body: followers})

      user = create(:user)
      key = create(:api_key, user: user)

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
      key = create(:api_key, user: user)

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
      key = create(:api_key, user: user)

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)
      within '#github_following' do
        expect(page).to have_link("moxie0", href: "https://github.com/moxie0")
      end
    end


  end
end
