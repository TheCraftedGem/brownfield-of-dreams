require 'rails_helper'

describe 'User' do
  it "can see tutorials marked 'classroom content'" do
    classroom_tutorial = create(:tutorial, classroom: true)
    other_tutorial = create(:tutorial)
    user = create(:user)

    page.driver.post(login_path, "session[email]"    => user.email,
                                 "session[password]" => user.password)

    visit tutorials_path
    expect(page).to have_content(other_tutorial.title)
    expect(page).to have_content(classroom_tutorial.title)
  end
end
