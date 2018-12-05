require 'rails_helper'

RSpec.feature "UserDashboards", type: :feature do
  describe 'dashboard' do
    it 'user can see github followers', :vcr do

      user = create(:user)
      key = create(:api_key, user: user)
      binding.pry

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)

      within("#github_followers") do

          expect(page).to have_link("BabyHughee",
                                     href: "https://github.com/BabyHughee")
      end
    end
  end
end
