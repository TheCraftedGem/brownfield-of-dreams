class User::ActivationController < ApplicationController
  def create
    # TODO: Set this up to redirect to a "successful activation" page, then the dashboard. Make sure to test.
    if current_user && current_user.id == params[:id].to_i
      current_user.update(active: true)
    end
    redirect_to dashboard_path
  end
end
