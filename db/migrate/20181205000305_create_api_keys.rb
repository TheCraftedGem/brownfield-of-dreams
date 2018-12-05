class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :key
      t.integer :source
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
