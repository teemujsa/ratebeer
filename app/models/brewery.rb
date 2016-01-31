class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  include RatingAverage

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

  def to_s
  	"#{brewery.name}"
  end
end
