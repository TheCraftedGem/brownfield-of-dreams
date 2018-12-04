require 'rails_helper'

RSpec.feature "UserDashboards", type: :feature do
  describe 'dashboard' do
  it 'user can see github followers', :vcr do

    user = create(:user)
    
    visit login_path

    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password

    click_on "Log In"

    expect(current_path).to eq(dashboard_path)

    within("#github_followers") do
    
      within(first(".follower")) do 
        expect(page).to have_content("averimj")
      end
    end
#    When I visit /dashboard
#   Then I should see a section for "Github"
#   And under that section I should see another section titled "Followers"
#   And I should see list of all followers with their handles linking to their Github profile 
  end
end
end
