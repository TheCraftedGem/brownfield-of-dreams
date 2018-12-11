class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_one :github_profile
  #IM NOT YOUR BUDDY, FRIEND!
  has_many :amigo_friends, foreign_key: :buddy_id, class_name: "Friendship"
  has_many :buddy_friends, foreign_key: :amigo_id, class_name: "Friendship"
  #IM NOT YOUR FRIEND, BUDDY!
  has_many :buddies, through: :buddy_friends
  has_many :amigos,  through: :amigo_friends

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

  def self.find_users_with_github_profiles(uids)
    self.select('users.*,
                  github_profiles.token AS github_key,
                  github_profiles.uid AS github_uid,
                  github_profiles.img_url AS img_url,
                  github_profiles.username AS username,
                  github_profiles.url AS url')
        .joins(:github_profile)
        .where(github_profiles: {uid: uids})
  end

  def friends
    # TODO: Refactor to make one query
    @_friends ||= (amigos + buddies).uniq
  end

  def friend_ids
    @_friend_ids ||= (amigos.ids + buddies.ids).uniq
  end

  def has_friend?(id)
    value = friend_ids.include?(id)
  end

  # TODO: Create methods for the github info for users that aren't found with the 'find_with_profiles' method (e.g. def github_key)
end
