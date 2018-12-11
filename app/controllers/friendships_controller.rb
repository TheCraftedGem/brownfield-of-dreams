class FriendshipsController < ApplicationController
  def create
    if User.where(id: friendship_params[:id]).empty?
      flash[:alert] = "User does not exist"
    elsif !current_user
      flash[:alert] = "You must be logged in to add friends"
    else
      @friend = Friendship.create_between(friendship_params[:id], current_user.id)
    end
    redirect_to dashboard_path
  end

  private

  def friendship_params
    params.permit(:id)
  end
end
