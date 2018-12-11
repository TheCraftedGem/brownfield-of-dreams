class GithubProfile < ApplicationRecord
  belongs_to :user

  def self.create_for_user(auth_hash, user)
    token = "TOKEN #{auth_hash[:credentials][:token]}"
    username = auth_hash[:info][:nickname]
    img_url = auth_hash[:info][:image]
    url = auth_hash[:info][:urls][:GitHub]
  
    profile = self.create_with(user: user,
                              token: token,
                              username: username,
                              img_url: img_url,
                              url: url)
                  .find_or_create_by(uid: auth_hash[:uid])
  end
end
