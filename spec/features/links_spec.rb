require 'rails_helper'

feature "Displaying Saved Links" do

  background do
    user = FactoryGirl.create(:user)
    visit "/users/sign_in"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log in"
    expect(page).to have_content("Signed in successfully.")
  end

  scenario 'User enters a new link' do
    visit "links/new"
    fill_in "Url", with: "https://www.ruby-lang.org"
    click_button "Create Link"
    expect(page).to have_text("Link was successfully created")
  end

  scenario "User selects a link from a list of saved links" do
    visit "/links/new"
    fill_in "Url", with: "http://www.mikeperham.com/2015/01/05/cgi-rubys-bare-metal/"
    click_button "Create Link"
    visit "/links"
    click_link "CGI: Ruby's Bare Metal"
    expect(page).to have_text("CGI: Ruby's Bare Metal")
  end

end
