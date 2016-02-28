class RatingsController < ApplicationController
  def index
  	@ratings = Rating.all
    @top3Beers = Beer.top 3
    @top3Breweries = Brewery.top 3
    @top3Raters = User.top 3
    @top3Styles = Style.top 3
    @recent = Rating.recent
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
end