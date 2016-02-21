require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting only letters" do
  	user = User.create username:"Pekka", password: "Secret"

  	expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a password with no upper case letters" do
  	user = User.create username:"Pekka", password: "secret1"

  	expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style of the highest average rating" do
      style1 = FactoryGirl.create :style
      style2 = FactoryGirl.create :style
      create_beer_with_rating_with_style(user, 10, style1)
      create_beer_with_rating_with_style(user, 30, style1)
      create_beer_with_rating_with_style(user, 15, style1)
      best = create_beer_with_rating_with_style(user, 25, style2)
      create_beer_with_rating_with_style(user, 35, style2)
      create_beer_with_rating_with_style(user, 15, style2)
      expect(user.favorite_style).to eq(best.style)
    end
  end

    describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated beer if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the style of the highest average rating" do
    	brewery1 = FactoryGirl.create(:brewery)
    	brewery2 = FactoryGirl.create(:brewery)
      create_beer_with_rating_with_brewery(user, 10, brewery1)
      create_beer_with_rating_with_brewery(user, 30, brewery1)
      create_beer_with_rating_with_brewery(user, 15, brewery1)
      best = create_beer_with_rating_with_brewery(user, 25, brewery2)
      create_beer_with_rating_with_brewery(user, 35, brewery2)
      create_beer_with_rating_with_brewery(user, 15, brewery2)
      expect(user.favorite_brewery).to eq(best.brewery)
    end
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end

def create_beer_with_rating_with_style(user, score, style)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_with_brewery(user, score, brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end