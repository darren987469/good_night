class CreateFollowings < ActiveRecord::Migration[5.2]
  def change
    create_table :followings do |t|
      t.bigint :user_id
      t.belongs_to :followed_user
      t.index [:user_id, :followed_user_id], unique: true
      t.timestamps
    end
  end
end
