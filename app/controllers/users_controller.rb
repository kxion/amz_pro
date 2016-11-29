class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(create_user_params)
    @user.save
    redirect_to login_path
  end

  def show
    @user = User.find(params[:id])
    if session[:user_id] != @user.id
      redirect_to root_path
      flash[:error] = "You do not have access to other users' profiles"
    else
      auth_hash = session[:auth_hash]
    end
  end

  private

    def create_user_params
      params.require(:user).permit(:username,:email,:password,:password_confirmation,:merchant_id)
    end

end
