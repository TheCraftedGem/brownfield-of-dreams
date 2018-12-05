require 'rails_helper'

RSpec.feature "UserDashboards", type: :feature do
  describe 'dashboard' do
    it 'user can see github followers', :vcr do

      user = create(:user)
 
      key = create(:api_key, user: user)
      

      visit '/'
    
      click_on "Register"
      fill_in :user_email, with: "#{user.email}"
      fill_in :user_password, with: 'test1234'
      fill_in :user_password_confirmation, with: 'test1234'
      fill_in :user_first_name, with: "#{user.first_name}"
      fill_in :user_last_name, with: "#{user.last_name}"
    
      click_on "Create Account"
     save_and_open_page
      expect(current_path).to eq(dashboard_path)
       
      within("#github_followers") do

          expect(page).to have_link("BabyHughee",
                                     href: "https://github.com/BabyHughee")
      end
      it "can see github repos", :vcr do 
        user = create(:user)
        key = create(:api_key, user: user)
        
        visit login_path

        fill_in 'session[email]', with: user.email
        fill_in 'session[password]', with: user.password
  
        click_on "Log In"
  
        expect(current_path).to eq(dashboard_path)
        save_and_open_page
        expect(page).to have
      end
    end
  end
end
