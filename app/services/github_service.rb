class GithubService
  def initialize(token)
    @token = token
  end

  def self.validate(token)
    return nil unless token
    new(token)
  end

  def get(type)
    get_json("/user/" + type.to_s)
  end

  private
    attr_reader :token

    def get_json(url)
      response = conn.get(url)
      parsed = JSON.parse(response.body, symbolize_names: true)
      raise parsed[:message] if parsed.class == Hash && parsed[:message]
      parsed
    end

    def conn
      Faraday.new(url: "https://api.github.com") do |faraday|
        faraday.headers["Authorization"] = token
        faraday.adapter Faraday.default_adapter
      end
    end
end
