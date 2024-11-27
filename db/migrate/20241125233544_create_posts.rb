class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :caption
      t.string :image_url
      t.string :body
      t.string :task_date
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
