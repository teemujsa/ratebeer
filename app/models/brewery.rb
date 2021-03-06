class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  include RatingAverage
  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
  validate :year_cant_be_past
  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  def year_cant_be_past
    if year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end
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
  	name
  end

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
