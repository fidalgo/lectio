require "rails_helper"

feature "User Accounts" do

  scenario "A User can sign up for an account" do
    user = FactoryGirl.build(:user)
    visit "/users/sign_up"
    fill_in "user_name", with: user.name
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    click_button "Sign up"
    expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  scenario "A User can login" do
    user = FactoryGirl.create(:user)
    visit "/users/sign_in"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log in"
    expect(page).to have_content("Signed in successfully.")
  end

# TODO: Refactor this scenario to a better approach, it should just ensure we can
# logout
  scenario "A User can logout" do
    user = FactoryGirl.create(:user)
    visit "/users/sign_in"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log in"
    expect(page).to have_content("Signed in successfully.")
    click_link('Logout')
    expect(page).to have_content("Signed out successfully.")
  end
  
end
