class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.belongs_to :amigo
      t.belongs_to :buddy

      t.timestamps
      t.index [:amigo_id, :buddy_id], unique: true
    end
  end
end
