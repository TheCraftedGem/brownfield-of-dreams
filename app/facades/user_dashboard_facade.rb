class UserDashboardFacade
  attr_reader :followers
  def initialize(user)
    @user = user
    @service = GithubService.new(user)
  end

  def followers
    @_followers ||= @service.get_followers.map do |follower_data|
      Follower.new(follower_data)
    end
  end

  def repos
    @_repos ||= @service.get_repos.map do |follower_data|
      Follower.new(follower_data)
    end
  end

end
