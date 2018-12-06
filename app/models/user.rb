class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_many :api_keys
  delegate :details, to: :github_key, prefix: true

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password
  validates_presence_of :first_name
  enum role: [:default, :admin]
  has_secure_password

  def github_key
    if token = self.api_keys.find_by(source: :github)
      token.key
    end
  end
end
