class Beer < ActiveRecord::Base
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  include RatingAverage
  validates :name, presence: true
  validates :style, presence: true

  def to_s
  	"#{name} by #{brewery.name}"
  end

  def average
  	return 0 if ratings.empty?
  	ratings.map {|r| r.score}.sum / ratings.count.to_f
  end

  def self.top(n)
    Beer.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
