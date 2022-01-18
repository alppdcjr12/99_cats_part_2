class UsersController < ApplicationController
  before_action :block_login_if_signed_in

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.session_token

      redirect_to :root
    else
      flash.now[:errors] = @user.errors["password"].map { |err| "Password " + err }
      flash.now[:errors] += @user.errors["password_digest"]
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
