describe Following, type: :model do
  describe '#follow_self' do
    it 'add error when user follow self' do
      following = Following.new(user_id: 1, followed_user_id: 1)
      expect(following.valid?).to eq false
    end
  end
end
