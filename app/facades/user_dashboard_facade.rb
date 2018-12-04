class UserDashboardFacade 
  attr_reader :followers
  def initialize(user)
    @user = user
  end

  def followers 
    @_followers ||= get_json.map do |follower_data|
      Follower.new(follower_data)
    end
  end

  def get_json
    conn = Faraday.new("https://api.github.com") do |faraday|
      faraday.headers["Authorization"] = ENV["GITHUB_API_KEY"]
      faraday.adapter Faraday.default_adapter
    end
    response = conn.get('/user/followers')
    JSON.parse(response.body, symbolize_names: true)
  end


end