class StaticPagesController < ApplicationController
  def home
    # create a micropost instance variable only if logged in
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
