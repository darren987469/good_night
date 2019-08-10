class CreateSleeps < ActiveRecord::Migration[5.2]
  def change
    create_table :sleeps do |t|
      t.belongs_to :user
      t.datetime :slept_at
      t.datetime :waked_at
      t.timestamps
    end
  end
end
