class ApplicationController < ActionController::Base
  helper_method :current_user
  

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login_user!(username, password)
    @user = User.find_by_credentials(username, password)
    if @user
      session[:session_token] = @user.reset_session_token!
      redirect_to cats_url
    else
      flash.now[:errors] = ["Username or password is incorrect."]
      render :new
    end
  end

  def block_login_if_signed_in
    return nil unless current_user
    if [["DELETE", "/session"], ["CREATE", "/users"]].include?(
      [request.method, request.fullpath]
    )
      redirect_to :root
    end
  end
end
