module SessionsHelper
  # Log the user in
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remember a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user == current_user
  end

  def current_user
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    # @current_user ||= User.find_by(id: session[:user_id])

    if( user_id = session[:user_id] )
      @current_user ||= User.find_by(id: user_id )      
    elsif( user_id = cookies.signed[:user_id] )
      user = User.find_by(id: user_id )
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    # current_user ? true : false
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # stores the url trying to be accessed
  # only if the request is get
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # redirects to stored location (or to default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
