require 'rails_helper'

feature 'Displaying Saved Links' do
  let(:user) { create(:user) }

  background do
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'User enters a new link' do
    visit new_link_path
    fill_in 'Url', with: 'https://www.ruby-lang.org'
    click_button 'Save'
    expect(page).to have_text('Link was successfully created')
  end

# TODO: refactor this scenario to mock the request.
  # scenario 'User selects a link from a list of saved links' do
  #   visit new_link_path
  #   fill_in 'Url', with: 'http://www.mikeperham.com/2015/01/05/cgi-rubys-bare-metal/'
  #   click_button 'Save'
  #   UrlScrapperJob.perform_now(Link.last)
  #   visit links_path
  #   click_link "CGI: Ruby's Bare Metal"
  #   expect(page).to have_text('CGI: Ruby\'s Bare Metal')
  # end

  scenario 'User marks link as read' do
    link = FactoryGirl.create(:link, user: user, read: false)
    visit read_link_path(link)
    link.reload
    expect(link.read).to eq(true)
  end

  scenario 'User marks link as unread' do
    link = FactoryGirl.create(:link, user: user, read: false)
    expect(link.read).to eq(false)
    visit read_link_path(link)
    link.reload
    expect(link.read).to eq(true)
    visit read_link_path(link)
    link.reload
    expect(link.read).to eq(false)
  end
end
