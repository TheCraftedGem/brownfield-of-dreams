class Github::User
  attr_reader :username,
              :url,
              :uid
  def initialize(data)
    @username = data[:login]
    @url = data[:html_url]
    @uid = data[:id]
  end
end
