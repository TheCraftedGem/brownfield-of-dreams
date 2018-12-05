require 'rails_helper'

RSpec.feature "UserDashboards", type: :feature do
  describe 'dashboard' do
    it 'user can see github followers', :vcr do

      user = create(:user)
      key = create(:api_key, user: user)

      visit login_path

      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password

      click_on "Log In"

      expect(current_path).to eq(dashboard_path)

      within("#github_followers") do
        save_and_open_page

          expect(page).to have_link("Thecraftedgem", href: "https://github.com/thecraftedgem")
    end

      it "can see github repos", :vcr do 
        user = create(:user)
        key = create(:api_key, user: user)
        
        visit login_path

        fill_in 'session[email]', with: user.email
        fill_in 'session[password]', with: user.password
  
        click_on "Log In"
  
        expect(current_path).to eq(dashboard_path)
        expect(page).to have
      end
    end
  end
end
