# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.find_or_create_by(name: 'user1')
user2 = User.find_or_create_by(name: 'user2')
user3 = User.find_or_create_by(name: 'user3')

Following.create(user: user1, followed_user: user2)
Following.create(user: user1, followed_user: user3)

def generate_sleeps(user)
  8.times do |index|
    num = index + 1
    sleep_hour = 20 + rand(1..3)
    slept_at = num.day.ago.change(hour: sleep_hour)
    wake_hour = 5 + rand(1..3)
    waked_at = index.day.ago.change(hour: wake_hour)
    Sleep.create(user: user, slept_at: slept_at, waked_at: waked_at)
  end
end

generate_sleeps(user1)
generate_sleeps(user2)
generate_sleeps(user3)
