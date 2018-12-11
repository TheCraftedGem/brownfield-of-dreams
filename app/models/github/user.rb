class Github::User
  attr_reader :name,
              :url
  def initialize(data)
    @name = data[:login]
    @url = data[:html_url]
  end
end
