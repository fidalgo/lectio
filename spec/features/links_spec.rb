require 'rails_helper'
require 'pry-byebug'

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
    visit 'links/new'
    fill_in 'Url', with: 'https://www.ruby-lang.org'
    click_button 'Create Link'
    expect(page).to have_text('Link was successfully created')
  end

  scenario 'User selects a link from a list of saved links' do
    visit '/links/new'
    fill_in 'Url', with: 'http://www.mikeperham.com/2015/01/05/cgi-rubys-bare-metal/'
    click_button 'Create Link'
    visit '/links'
    click_link 'CGI: Ruby\'s Bare Metal'
    expect(page).to have_text('CGI: Ruby\'s Bare Metal')
  end

  scenario 'User marks link as read' do
    link = FactoryGirl.create(:link, user: user)
    visit read_link_path(link)
    link = Link.find(link.id)
    expect(link.read).to eq(true)
  end

  scenario 'User marks link as unread' do
    link = FactoryGirl.create(:link, user: user)
    expect(link.read).to eq(false)
    visit read_link_path(link)
    link = Link.find(link.id)
    expect(link.read).to eq(true)
    visit read_link_path(link)
    link = Link.find(link.id)
    expect(link.read).to eq(false)
  end
end
