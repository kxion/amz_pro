class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(create_user_params)
    @user.save
    redirect_to @user
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def create_user_params
      params.require(:user).permit(:username,:email,:password,:password_confirmation,:merchant_id)
    end

end
