require 'rails_helper'
require 'user'


def login(user)
  visit root_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Login'
end


feature "Signing in" do
  background do
    @user = User.create(:email => 'user@example.com', :password => 'caplin')
  end

  scenario "Signing in with correct credentials" do

    visit root_path
    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    click_button 'Login'

    expect(page).to have_content 'Control Center'
  end
end

feature "home page" do
  background do
    @user = User.create(:email => 'user@example.com', :password => 'caplin')
  end

  scenario "page loads correctly", js: true do
    login(@user)
    expect(page).to have_content 'Widget 1'
  end

  scenario "click employee button", js: true do
    login(@user)
    find_button('employees').click
    expect(page).to have_content 'Widget 3'
  end

  scenario "click sales button", js: true do
    login(@user)
    find_button('sales').click
    expect(page).to have_content 'Widget 3'
  end

  scenario "click clear button", js: true do
    login(@user)
    find_button('Clear').click
    expect(page).not_to have_content 'Widget 1'
  end

end