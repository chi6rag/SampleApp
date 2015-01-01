class AccountActivationsController < ApplicationController
  
  def edit
    # find the user by his email address
    # if it exists, is unactivated and authentication details match, activate, login and redirect to userpath
    # else flash invalid and redirect back to root
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
