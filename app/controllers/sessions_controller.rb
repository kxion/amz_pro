class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password)
    @user = User.confirm(user_params)
    if @user
      session[:user_id] = @user.id
      session[:merchant_id] = @user.merchant_id
      @current_user = @user
      flash[:success] = "Successfully logged in."
      redirect_to '/auth/amazon'
    else
      flash[:error] = "Incorrect email or password."
      redirect_to login_path
    end
  end

  def update
    auth_hash = request.env['omniauth.auth']
    session[:auth_hash] = auth_hash
    redirect_to welcome_index_path
  end

end
