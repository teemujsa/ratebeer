require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has the name and style set correctly" do
    style = Style.create name:"SomeStyle", description:"SomeDesc"
    beer = Beer.create name:"Karjala", style: style

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved, if name is not set" do
    style = Style.create name:"SomeStyle", description:"SomeDesc"
    beer = Beer.create style: style

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved, if style is not set" do
    beer = Beer.create name:"Karjala"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
