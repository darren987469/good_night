describe Entity::V1::User do
  let(:user) { create(:user, name: 'user') }

  subject { described_class.new(user).as_json }

  specify do
    {
      id: user.id,
      name: user.name
    }.each do |key, expected_val|
      expect(subject[key]).to eq expected_val
    end
  end
end
