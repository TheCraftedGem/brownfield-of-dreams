class GithubProfilesController < ApplicationController
  def create
    GithubProfile.create_for_user(auth_hash, current_user)
    redirect_to dashboard_path
  end

  def destroy
    current_user.github_profile.destroy
    redirect_to dashboard_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
