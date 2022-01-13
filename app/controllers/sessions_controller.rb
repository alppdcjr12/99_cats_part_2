class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)

    if @user
      session[session_token] = @user.reset_session_token!
      redirect_to cats_url
    else
      flash.now[:errors] = ["Username or password is incorrect."]
      render :new
    end

  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
