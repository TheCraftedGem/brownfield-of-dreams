class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_one :github_profile

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password
  validates_presence_of :first_name
  enum role: [:default, :admin]
  has_secure_password

  def github_key
    self.github_profile.token if self.github_profile
  end
end
