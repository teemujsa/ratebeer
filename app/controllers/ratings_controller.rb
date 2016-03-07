class RatingsController < ApplicationController
  before_action :skip_if_cached, only:[:index]

  def skip_if_cached
    return render :index if fragment_exist?( 'ratings-page'  )
  end

  #Some optimization by using the already retrieved ratings in some of the top queries
  def index
  	@ratings = Rating.includes(:user, beer: :brewery).all
    @top3Beers = topbeer @ratings, 3
    @top3Breweries = topbrewery @ratings, 3
    @top3Raters = User.top 3
    @top3Styles = topstyle @ratings, 3
    @recent = @ratings.order(created_at: :desc).limit(5)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
  @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  def topbeer(ratings, n)
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    ratings.sort_by{|r| -r.score}.take(n).map{|x| x.beer}
  end

  def topstyle(ratings, n)
    top ratings, n, :style
  end

  def topbrewery(ratings, n)
    top ratings, n, :brewery
  end

  def top(ratings, n, category)
    return nil if ratings.empty?
    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(ratings, category, item) }.take(n)
  end

  def rating_of(ratings, category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end
end