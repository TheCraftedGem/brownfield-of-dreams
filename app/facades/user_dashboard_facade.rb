class UserDashboardFacade
  attr_reader :followers, :user, :github_adapter
  def initialize(user)
    @user = user
    @github_adapter = Github::ServiceAdapter.new(user)
  end

  def followers
    github_adapter.followers
  end

  def repos(quantity: 5)
    github_adapter.repos.last(quantity) if github_adapter.repos
  end

  def following
    github_adapter.following
  end

  def suggested_friendships 
    github_adapter.connection_uids
  end
  
  def friends 
    user.friends
  end

  def bookmarks
    user.bookmarks
  end
end
