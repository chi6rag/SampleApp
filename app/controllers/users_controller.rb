class UsersController < ApplicationController
  # by default, before filters apply to every action but the statement
  # only: [:edit, :update]
  # limits the filter to edit and update actions only
  before_action :logged_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Congratulations! You have been successfully registered."
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.delete
      flash[:success] = "Successfully deleted user #{params[:id]}"
      redirect_to users_url
    else
      flash.now[:danger] = "Delete failed"
      render users_url
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # confirms a logged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end

  # used to filter malcious users from updating the profiles of other users
  # identifies that the user who has logged in when sends a patch request to
  # update action with id of a different user, he gets redirected to the root url
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
