class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.select{|bc| !Membership.all.find_by beer_club_id: bc.id, user_id: current_user}
  end

  # GET /memberships/1/edit
  def edit
  end

  def approve
    beer_club = BeerClub.find(params[:beer_club_id].to_i)
    if(current_user and beer_club.members.include? current_user)
      membership = beer_club.applications.select{|x| x.user.id == params[:user_id].to_i}.first
      membership.confirmed = true
      membership.save
      redirect_to :back, notice: "Member #{membership.user.username} confirmed"
    else
      redirect_to signin_path, notice: "Sign in as a member to approve"
    end
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)

    if @membership.save
      current_user.memberships << @membership
      redirect_to @membership.beer_club, notice: "#{current_user.username}, welcome to the club!"
    else
      render :new
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    club = @membership.beer_club
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{club.name} ended." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
