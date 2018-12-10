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
            github_profiles.username AS github_username,
            github_profiles.url AS github_url')
    .left_outer_joins(:github_profile)
    .where(id: user_id)
    .limit(1)
    .first
  end
  # TODO: Create methods for the github info for users that aren't found with the 'find_with_profiles' method (e.g. def github_key)
end
