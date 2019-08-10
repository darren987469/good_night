class User < ApplicationRecord
  has_many :followings
  has_many :followed_users, through: :followings
  has_many :followerships, foreign_key: :followed_user_id, class_name: 'Following'
  has_many :followers, through: :followerships, source: :user
  has_many :sleeps
end
