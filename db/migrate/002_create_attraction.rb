class CreateAttraction < ActiveRecord::Migration[5.0]
  def change
    create_table :attractions do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :author_id
      t.string :description
      t.timestamps
    end
  end
end
