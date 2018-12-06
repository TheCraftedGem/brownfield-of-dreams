class UserDashboardFacade
  attr_reader :followers, :user, :github_adapter
  def initialize(user)
    @user = user
    @github_adapter = GithubAdapter.new(user)
  end

  def followers
    github_adapter.followers
  end

  def repos
    github_adapter.repos
  end

  def following
    github_adapter.following
  end
end
