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
		if not(password.match(/\p{Upper}/))
	      errors.add(:password, "doesn't have upper case chars")
	    end
	end
end
