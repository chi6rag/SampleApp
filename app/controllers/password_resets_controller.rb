class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    # find the user in the database
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # if user exists
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    # four border cases
      # expired reset - done
      # successful update - done
      # failed update due to invalid password - done
      # failed update due to a blank password
    # end
    if both_passwords_blank?
      flash.now[:danger] = "Password/confirmation cannot be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private
  # finds the user in the database and return the user
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # confirms a valid user
  def valid_user
    # checks user
    # checks user is authenticated
    # checks user is activated
    unless ( @user && @user.activated? && @user.authenticated?(:reset, params[:id]) )
      # note: params[:id] contains reset token
      flash[:danger] = "Invalid user"
      redirect_to root_url
    end
  end

  # confirms if reset token is valid - limit 2 hrs from the time of generation
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset expired"
      redirect_to new_password_reset_url
    end
  end

  # returns true if both the passwords in reset page are blank else false
  def both_passwords_blank?
    params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
