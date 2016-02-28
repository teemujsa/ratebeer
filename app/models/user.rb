class User < ActiveRecord::Base
	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships
	include RatingAverage
	has_secure_password
	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	validates :password, length: { minimum: 4 }
	validate :password_has_numbers
	validate :password_has_upper_case

    def self.top(n)
        User.all.sort_by{ |b| -(b.ratings.count||0) }.take(n)
    end

    def to_s
        self.username
    end

	def password_has_numbers
		if not(password =~ /\d/)
	      errors.add(:password, "doesn't have numbers")
	    end
	end

	def password_has_upper_case
		if not(password =~ /[A-Z]/)
	      errors.add(:password, "doesn't have upper case chars")
	    end
	end

	def favorite_beer
    	return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    	ratings.sort_by{|r| -r.score}.first.beer
    end

    def favorite_style
    	favorite :style
    end

    def favorite_brewery
    	favorite :brewery
    end

    def favorite(category)
    	return nil if ratings.empty?
    	rated = ratings.map{ |r| r.beer.send(category) }.uniq
    	rated.sort_by { |item| -rating_of(category, item) }.first
    end

    def rating_of(category, item)
	    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
	    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
	end
end
