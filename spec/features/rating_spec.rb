require 'rails_helper'
include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "count and ratings are displayed on the list of ratings" do
    r1 = FactoryGirl.create :rating, user:user, beer:beer1
    r2 = FactoryGirl.create :rating, user:user, beer:beer1
    r3 = FactoryGirl.create :rating, user:user, beer:beer1
    visit ratings_path
    expect(page).to have_content "Number of ratings: 3"
    expect(page).to have_content r1.to_s
    expect(page).to have_content r2.to_s
    expect(page).to have_content r3.to_s
  end

  it "of the user are displayed on the users page, but no other" do
    user2 = FactoryGirl.create :user, username:"Teemu", password:"Teemu1", password_confirmation:"Teemu1"
    r1 = FactoryGirl.create :rating, user:user, beer:beer1
    r2 = FactoryGirl.create :rating, user:user, beer:beer1
    r3 = FactoryGirl.create :rating, user:user2, beer:beer2
    visit user_path(user)
    expect(page).to have_content r1.to_s
    expect(page).to have_content r2.to_s
    expect(page).to have_no_content r3.to_s
  end

  it "is deleted from database when corresponding user deletes it" do
    r1 = FactoryGirl.create :rating, user:user, beer:beer1
    r2 = FactoryGirl.create :rating, user:user, beer:beer1
    r3 = FactoryGirl.create :rating, user:user, beer:beer1
    visit user_path(user)
    #save_and_open_page
    expect(user.ratings.count).to eq(3)
    page.all('a', :text => 'delete').first.click
    expect(user.ratings.count).to eq(2)
  end

  it "is used to get favorite beer which is displayed on user's page" do
    FactoryGirl.create :rating, score:20, user:user, beer:beer1
    FactoryGirl.create :rating, score:28, user:user, beer:beer2
    visit user_path(user)
    #save_and_open_page
    expect(page).to have_content "Favorite beer: #{beer2}"
  end

  it "is used to get favorite brewery which is displayed on user's page" do
    brew1 = FactoryGirl.create :brewery, name:"Koff"
    brew2 = FactoryGirl.create :brewery, name:"Hartwall"
    b1 = FactoryGirl.create :beer, name:"Karhu", brewery:brew1
    b2 = FactoryGirl.create :beer, name:"Karjala", brewery:brew2
    FactoryGirl.create :rating, score:20, user:user, beer:b1
    FactoryGirl.create :rating, score:28, user:user, beer:b2
    visit user_path(user)
    #save_and_open_page
    expect(page).to have_content "Favorite brewery: #{b2.brewery}"
  end
end