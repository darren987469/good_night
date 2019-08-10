describe Entity::V1::SleepWithUser do
  let(:user) { create(:user, name: 'user') }
  let(:slept_at) { Time.new(2019, 8, 9, 22) }
  let(:waked_at) { Time.new(2019, 8, 10, 6) }
  let(:sleep) { create(:sleep, user: user, slept_at: slept_at, waked_at: waked_at) }

  subject { described_class.new(sleep).as_json }

  specify do
    {
      id: sleep.id,
      slept_at: slept_at,
      waked_at: waked_at,
      user: Entity::V1::User.new(user).as_json,
      sleep_length: 'about 8 hours'
    }.each do |key, expected_val|
      expect(subject[key]).to eq expected_val
    end
  end
end
