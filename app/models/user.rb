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
    	ratings.group_by{|r| r.beer}
            .inject{|highest,x| max_rating(highest,x)}.first
    end

    def favorite_style
    	return nil if ratings.empty?
    	ratings.group_by{|r| r.beer.style}
    		.inject{|highest,x| max_rating(highest,x)}.first
    end

    def favorite_brewery
    	return nil if ratings.empty?
    	ratings.group_by{|r| r.beer.brewery}
    		.inject{|highest,x| max_rating(highest,x)}.first
    end

    def max_rating(ratings1, ratings2)
    	ave1 = average_rating_helper(ratings1[1])
    	ave2 = average_rating_helper(ratings2[1])
    	return ratings1 if ave1 > ave2
    	ratings2
    end

    def average_rating_helper(rates)
    	rates.map{|x| x.score}.inject{|sum,y| sum + y} / ratings.count
    end
end
