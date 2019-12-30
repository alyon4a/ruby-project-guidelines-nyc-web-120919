class CreateReview < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :attraction_id
      t.integer :rating
      t.string :content
      t.timestamps
    end
  end
end
