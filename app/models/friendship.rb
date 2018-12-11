class Friendship < ApplicationRecord
  belongs_to :amigo, class_name: "User"
  belongs_to :buddy, class_name: "User"

  def self.create_between(buddy_id, amigo_id)
    self.create(amigo_id: amigo_id, buddy_id: buddy_id)
  end
end
