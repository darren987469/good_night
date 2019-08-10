describe Entity::V1::Following do
  let(:user1) { create(:user, name: 'user1') }
  let(:user2) { create(:user, name: 'user2') }
  let(:following) { create(:following, user: user1, followed_user: user2) }

  subject { described_class.new(following).as_json }

  specify do
    {
      user_id: user1.id,
      followed_user_id: user2.id
    }.each do |key, expected_val|
      expect(subject[key]).to eq expected_val
    end
  end
end
