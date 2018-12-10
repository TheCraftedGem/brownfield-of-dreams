class GithubProfile < ApplicationRecord
  belongs_to :user

  def self.link(auth_hash, user)
    token = "TOKEN #{auth_hash[:credentials][:token]}"
    username = auth_hash[:info][:nickname]
    img_url = auth_hash[:info][:image]
    url = auth_hash[:info][:urls][:github]
    profile = self.create_with(user: user,
                              token: token,
                              username: username,
                              img_url: img_url,
                              url: url)
                  .find_or_create_by(user_id: user.id)

  end
end
