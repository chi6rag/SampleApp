module SessionsHelper
  # Log the user in
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    # current_user ? true : false
    !current_user.nil?
  end
end
