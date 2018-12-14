class GithubInviteController < ApplicationController
  def create
    redirect_to dashboard_path
    begin
      result = send_invitation
      flash[:notice] = "Successfully sent invite!" if result
      flash[:notice] = "Sorry, your friend's email address is unavailable..." if result == :failed
    rescue BadCredentials
      flash[:notice] = "Sorry, we couldn't send an invite at this time."
    end
  end

  private
  # OPTIMIZE: Add "name" column to GithubProfile instead of making an api call for current user.
    def send_invitation
      current_user && @service = GithubService.new(current_user.github_key)
      invitee = @service.get(params[:handle], path: "users")
      sender = @service.get(current_user.github_username, path: "users")
      UserMailer.github_invite_email(invitee, sender, request.base_url)
                .deliver_now
    end
end
