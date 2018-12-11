class FriendshipsController < ApplicationController
  def create
    if current_user
      @friend = Friendship.create_between(friendship_params[:id], current_user.id)
    end
    redirect_to dashboard_path
  end

  private 

  def friendship_params
    params.permit(:id)
  end
end
