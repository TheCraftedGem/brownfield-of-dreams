class Github::ServiceAdapter < ServiceAdapter

  def initialize(user)
    @token = user.github_key
    @_followers = nil
    @_following = nil
    @_repos = nil
    @_service = nil
    @_null_service = nil
  end

  def followers
    @_followers ||= service_call(:followers, Github::User)
  end

  def repos
    @_repos ||= service_call(:repos, Github::Repo)
  end

  def following
    @_following ||= service_call(:following, Github::User)
  end

  def connection_uids 
    uids = (followers.map { |f| f.uid } + following.map { |f| f.uid }).uniq
    User.find_users_with_github_profiles(uids)
  end

  private
    attr_reader :token, :service, :null_service, :user

    def service
      @_service ||= GithubService.validate(token) || null_service
    end

    def null_service
      @_null_service ||= Null::GithubService.new(nil)
    end
end
