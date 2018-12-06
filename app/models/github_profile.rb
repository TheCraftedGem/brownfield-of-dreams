class GithubProfile
  include ServiceHelper

  def initialize(user)
    @token = user.github_key
    @_followers = nil
    @_following = nil
    @_repos = nil
    @_service = nil
    @_null_service = nil
  end

  def followers
    @_followers ||= service_call(:followers)
  end

  def repos
    @_repos ||= service_call(:repos)
  end

  def following
    @_following ||= service_call(:following)
  end

  private
    attr_reader :token, :service, :null_service

    def service
      @_service ||= GithubService.validate(token) || null_service
    end

    def null_service
      @_null_service ||= Null::GithubService.new(nil)
    end
end
