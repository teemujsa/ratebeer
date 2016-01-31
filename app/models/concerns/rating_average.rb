module RatingAverage
	extend ActiveSupport::Concern
	def average_rating
  		sum = ratings.map{|r| r.score}.inject { |sum, r| sum + r}
  		sum / ratings.count
 	end
end