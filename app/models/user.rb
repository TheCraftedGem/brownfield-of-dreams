class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_one :github_profile

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password
  validates_presence_of :first_name
  enum role: [:default, :admin]
  has_secure_password

  def self.find_with_profiles(user_id)
    select('users.*,
            github_profiles.token AS github_key,
            github_profiles.uid AS github_uid,
            github_profiles.img_url AS img_url,
            github_profiles.username AS github_username')
    .left_outer_joins(:github_profile)
    .where(id: user_id)
    .limit(1)
    .first
  end
end
