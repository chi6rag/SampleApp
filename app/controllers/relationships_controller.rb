class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # find the user to follow by params followed_id
  # follow the user
  def create
    @user = User.find(params[:followed_id])   # made variable for ajax
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
