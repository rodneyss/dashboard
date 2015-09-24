require 'rails_helper'

feature "user visits home page" do
  scenario "they see Rodney on page" do
    visit '/'
  
    expect(page).to have_content 'Rodney'
  end
end