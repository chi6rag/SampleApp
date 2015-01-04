class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # find the user to follow by params followed_id
  # follow the user
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = User.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end

end
