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
        expect(page).to have_link("LaughTracks", href: "https://github.com/wfischer42/LaughTracks")
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

    it 'can connect to github' do
      stub_omniauth
      user_1 = create(:user)
      user_2 = create(:user)

      page.driver.post(login_path, "session[email]" => user_1.email, "session[password]" => user_1.password)

      visit dashboard_path
      click_button "Connect on GitHub"

      expect(user_1.github_profile.token).to eq('TOKEN 12345')
      expect(page).to have_content("GitHub Account: #{user_1.github_profile.username}")
      expect(page).to_not have_button('Connect on GitHub')
    end

    it 'can disconnect from github' do
      stub_omniauth
      user_1 = create(:user)
      user_2 = create(:user)

      page.driver.post(login_path, "session[email]" => user_1.email, "session[password]" => user_1.password)
      visit dashboard_path
      click_button "Connect on GitHub"
      click_button "Disconnect GitHub Account"

      expect(page).to have_button('Connect on GitHub')
    end


    it 'can see suggested friendships in followers and following sections' do
      followers = File.open("./spec/fixtures/followers.json")
      stub_request(:get, "https://api.github.com/user/followers")
        .to_return({body: followers})


      user_1 = create(:user)
      user_2 = create(:user)

      github_profile_1 = create(:github_profile, user: user_1, uid: 16843426, token: ENV["GH_TOKEN_1"])
      github_profile_2 = create(:github_profile, user: user_2, uid: 38091448, token: ENV["GH_TOKEN_2"])

      page.driver.post(login_path, "session[email]" => user_2.email, "session[password]" => user_2.password)

      visit dashboard_path

      within "#github_following" do
        expect(page).to have_button("Add as Friend")
      end
      within "#github_followers" do
        expect(page).to have_button("Add as Friend")
      end
    end

    it 'can add friend' do
      followers = File.open("./spec/fixtures/followers.json")
      stub_request(:get, "https://api.github.com/user/followers")
        .to_return({body: followers})


      user_1 = create(:user)
      user_2 = create(:user)

      github_profile_1 = create(:github_profile, user: user_1, uid: 16843426, token: ENV["GH_TOKEN_1"])
      github_profile_2 = create(:github_profile, user: user_2, uid: 38091448, token: ENV["GH_TOKEN_2"])

      page.driver.post(login_path, "session[email]" => user_2.email, "session[password]" => user_2.password)

      visit dashboard_path

      click_on("Add as Friend", match: :first)

      expect(page).to have_current_path(dashboard_path)

      within ".friendships" do
        expect(page).to have_content(user_1.first_name)
      end

      within "#github_following" do
        expect(page).to_not have_button("Add as Friend")
      end

      within "#github_followers" do
        expect(page).to_not have_button("Add as Friend")
      end
    end

    it 'prevents friending with nil user and sends alert' do
      user = create(:user, id: 1)

      page.driver.post(login_path, "session[email]" => user.email, "session[password]" => user.password)

      page.driver.post(create_friendship_path, id: 2)

      click_on "redirected"
      expect(page).to have_content("User does not exist")
    end

    it 'prevents friending unless logged in' do
      user_1 = create(:user)

      page.driver.post(create_friendship_path, id: user_1.id)

      click_on "redirected"
      expect(page).to have_content("You must be logged in to add friends")
    end

    it "gets validates email message" do
      first_name = "oscar"
      visit "/"
      click_on "Register"
      
      fill_in "user[email]", with: "test@test.com"
      fill_in "user[first_name]", with: first_name
      fill_in "user[last_name]", with: "test"
      fill_in "user[password]", with: "test"
      fill_in "user[password_confirmation]", with: "test"

      click_on "Create Account"
      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content("Logged in as #{first_name}")
      expect(page).to have_content("This account has not yet been activated. Please check your email.")
      expect(ActionMailer::Base.deliveries.first.subject).to include(first_name)
    end


    it 'can add videos to their bookmarks' do
      tutorial= create(:tutorial, title: "How to Tie Your Shoes")
      video = create(:video, title: "The Bunny Ears Technique", tutorial: tutorial)
      user = create(:user)

      expect(UserVideo.count).to eq(0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit tutorial_path(tutorial)

      click_on 'Bookmark'

      expect(UserVideo.count).to eq(1)
      expect(page).to have_content("Bookmark added to your dashboard")
    end

  it "can't add the same bookmark more than once" do
    tutorial= create(:tutorial)
    video = create(:video, tutorial_id: tutorial.id)
    user_1 = create(:user)
    user_2 = create(:user)

    github_profile_1 = create(:github_profile, user: user_1, uid: 16843426, token: ENV["GH_TOKEN_1"])
    github_profile_2 = create(:github_profile, user: user_2, uid: 38091448, token: ENV["GH_TOKEN_2"])

    page.driver.post(login_path, "session[email]" => user_2.email, "session[password]" => user_2.password)

    visit dashboard_path


    visit tutorial_path(tutorial)

    click_on 'Bookmark'
    expect(page).to have_content("Bookmark added to your dashboard")
    click_on 'Bookmark'
    expect(page).to have_content("Already in your bookmarks")
  end

  it 'can see bookmarked videos on their dashboard' do
    tutorial_1 = create(:tutorial, title: "How to Ruby")
    tutorial_2 = create(:tutorial, title: "How to Find Books")
    video_1 = create(:video, title: "Ruby The Hard Way", tutorial_id: tutorial_1.id, position: 0)
    video_2 = create(:video, title: "Don't Do Stupid", tutorial_id: tutorial_1.id, position: 1)
    video_3 = create(:video, title: "For The Love Of Rails", tutorial_id: tutorial_2.id, position: 1)
    video_4 = create(:video, title: "Bagels And Databases", tutorial_id: tutorial_2.id, position: 0)
    user_1 = create(:user)
    github_profile_1 = create(:github_profile, user: user_1, uid: 16843426, token: ENV["GH_TOKEN_1"])
    user_video_1 = create(:user_video, user_id: user_1.id, video_id: video_1.id)
    user_video_2 = create(:user_video, user_id: user_1.id, video_id: video_2.id)
    _1_video_3 = create(:user_video, user_id: user_1.id, video_id: video_3.id)
    user_video_4 = create(:user_video, user_id: user_1.id, video_id: video_4.id)
    
    page.driver.post(login_path, "session[email]" => user_1.email, "session[password]" => user_1.password)
    
    visit dashboard_path

    within("#bookmarks") do
      expect(page).to have_content("Bookmarked Segments")
      save_and_open_page
    end
end


    def stub_omniauth
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash
        .new( { 'provider'=>'github',
                'uid' => '54321',
                'credentials' => { 'token' => '12345' },
                'info'=> {'nickname'=> 'jschmoe',
                          'email'=> 'jschmoe@email',
                          'image'=> 'https://image.url',
                          'urls'=>{ 'GitHub'=>'https://github.com/user1'} } } )
    end
  end
end
