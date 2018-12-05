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
    self.api_keys.where(source: :github).first.key
  end
end
