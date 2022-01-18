class SessionsController < ApplicationController
  before_action :block_login_if_signed_in
  
  def new
    render :new
  end

  def create
    username, password = user_params[:username], user_params[:password]
    login_user!(username, password)
  end

  def destroy
    current_user.reset_session_token! if current_user
    session.delete(:session_token)
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
