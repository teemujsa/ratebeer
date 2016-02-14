require 'rails_helper'
include Helpers

describe "Beer" do
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is added to database if name is valid" do
    visit new_beer_path
    fill_in('beer[name]', with:'validi')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not added to database if name is invalid" do
    visit new_beer_path
    fill_in('beer[name]', with:'')
    click_button "Create Beer"
    #save_and_open_page
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end