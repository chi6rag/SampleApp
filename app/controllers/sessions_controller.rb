class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # login the user
    else
      # create an error message
      flash.now[:danger] = "Wrong email/password"
      render 'new'
    end
  end
end
