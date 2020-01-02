class CreateAttractionLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :attraction_likes do |t|
      t.integer :attraction_id
      t.integer :user_id
      t.timestamp
    end
  end
end
