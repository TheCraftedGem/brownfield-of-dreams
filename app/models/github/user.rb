class Github::User
  attr_reader :username,
              :url,
              :uid
  def initialize(data)
    @username = data[:login]
    @url = data[:html_url]
    @uid = data[:id]
  end

  def is_user?
    return true if profile
  end

  def id
    @_id = profile.user_id if profile
  end

  private
    def profile
      @_profile ||= GithubProfile.find_by(uid: @uid)
    end
end
