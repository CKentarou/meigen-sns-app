class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.string :author
      t.integer :user_id

      t.timestamps
    end
  end
end
