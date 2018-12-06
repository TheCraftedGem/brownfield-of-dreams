class UserDashboardFacade
  attr_reader :followers, :user, :github_profile
  def initialize(user)
    @user = user
    @github_profile = GithubProfile.new(user)
  end

  def followers
    github_profile.followers
  end

  def repos
    github_profile.repos
  end
end
