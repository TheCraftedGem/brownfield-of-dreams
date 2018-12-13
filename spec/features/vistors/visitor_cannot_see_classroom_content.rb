require 'rails_helper'

describe 'visitor' do
  it "cannot see tutorials marked 'classroom content'" do
    classroom_tutorial = create(:tutorial, classroom: true)
    other_tutorial = create(:tutorial)
    visit tutorials_path
    expect(page).to have_content(other_tutorial.title)
    expect(page).to_not have_content(classroom_tutorial.title)
  end

end
