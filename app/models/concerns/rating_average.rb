module RatingAverage
	extend ActiveSupport::Concern
	def average_rating
		return 0 if ratings.count == 0
  		sum = ratings.map{|r| r.score}.inject { |sum, r| sum + r}
  		sum.to_f / ratings.count
 	end
end