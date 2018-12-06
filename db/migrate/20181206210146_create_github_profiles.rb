class CreateGithubProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :github_profiles do |t|
      t.integer :uid
      t.string :token
      t.string :username
      t.string :img_url
      t.string :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
