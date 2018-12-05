class UserDashboardFacade
  attr_reader :followers
  def initialize(user)
    @user = user
  end

  def followers
    @_followers ||= @service.get_followers.map do |follower_data|
      Follower.new(follower_data)
    end
  end

  def repos
    @_repos ||= @service.get_repos[0..4].map do |follower_data|
      Follower.new(follower_data)
    end
  end

  def service 
    if user.github_key
      @service ||= GithubService.new(user) 
    else 
      NullKey.new
    end
  end

end
