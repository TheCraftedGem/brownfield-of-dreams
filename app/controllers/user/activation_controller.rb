class User::ActivationController < ApplicationController
  def create
    if current_user && current_user.id == params[:id].to_i
      current_user.update(active: true)
    end
    redirect_to dashboard_path
  end
end
