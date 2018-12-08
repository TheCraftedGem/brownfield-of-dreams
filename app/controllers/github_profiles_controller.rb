class GithubProfilesController < ApplicationController
  def create
    GithubProfile.link(auth_hash, current_user)
    redirect_to dashboard_path
  end

  def destroy
    redirect_to dashboard_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
