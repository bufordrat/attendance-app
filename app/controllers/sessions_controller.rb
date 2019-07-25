class SessionsController < ApplicationController

  def new
  end
  
  def create
    @user = User.find_by(cnetid: params["cnetid"].downcase.strip)

    if @user != nil
      if @user.authenticate(params["password"])
        session["user_id"] = @user.id
        if @user.is_teacher == true
          redirect_to "/dashboard"
        else
          redirect_to "/users/#{@user.id}"
        end
      else
        redirect_to root_url, alert: "You must have mistyped your password."
      end
    else
      redirect_to root_url, alert: "That cnetid doesn't have an account yet.  Please create an account."
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "You are now logged out."
  end

  def four_oh_four
    @user = User.find_by(id: session["user_id"])
    if @user.blank?
      redirect_to root_url, alert: "That address doesn't exist."
    else
      redirect_to "/users/#{@user.id}", alert: "That address doesn't exist."
    end
  end

  def blank_user
    @user = User.find_by(id: session["user_id"])
    if @user.blank?
      redirect_to root_url, alert: "Cnetid field must not be blank."
    end
  end
end
