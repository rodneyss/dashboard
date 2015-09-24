require 'rails_helper'

feature "visit home page" do

  scenario "page loads correctly", js: true do
    visit '/'
    expect(page).to have_content 'Widget 1'
  end

  scenario "click employee button", js: true do
    visit '/'
    find_button('employees').click
    expect(page).to have_content 'Widget 3'
  end

  scenario "click sales button", js: true do
    visit '/'
    find_button('sales').click
    expect(page).to have_content 'Widget 3'
  end

  scenario "click clear button", js: true do
    visit '/'
    find_button('Clear').click
    expect(page).not_to have_content 'Widget 1'
  end
end