class SessionsController < ApplicationController

  def create_oauth
    redirect_to "/"
    byebug
  end

  def failure
    redirect_to "/"
    byebug
  end

  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user and not user.active
      redirect_to :back, notice: "Your account is frozen, please contact admin"
    elsif user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to :back, notice: "Username and/or password mismatch"
      end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end