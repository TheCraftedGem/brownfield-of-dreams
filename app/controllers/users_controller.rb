class UsersController < ApplicationController

  def show
    unless current_user
      render "sessions/new"
      return
    end
    @facade = UserDashboardFacade.new(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Username already exists'
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password)
    end
end
