require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has the name and style set correctly" do
    beer = Beer.create name:"Karjala", style: "IPA"

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved, if name is not set" do
    beer = Beer.create style: "IPA"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved, if style is not set" do
    beer = Beer.create name:"Karjala"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
