describe Sleep, type: :model do
  let(:user) { create(:user) }

  describe 'validates overlap' do
    context 'when overlap exists' do
      let(:slept_at) { Time.new(2019, 8, 10, 22) }
      let(:waked_at) { Time.new(2019, 8, 11, 6) }

      before { create(:sleep, user: user, slept_at: slept_at, waked_at: waked_at) }

      it 'adds error' do
        sleep = build(:sleep, user: user, slept_at: slept_at, waked_at: waked_at)
        expect(sleep.valid?).to eq false
      end
    end

    context 'when no overlap exists' do
      let(:slept_at) { Time.new(2019, 8, 10, 22) }
      let(:waked_at) { Time.new(2019, 8, 11, 6) }

      before { create(:sleep, user: user, slept_at: slept_at, waked_at: waked_at) }

      it 'passes the validation' do
        slept_at = Time.new(2019, 8, 11, 22)
        waked_at = Time.new(2019, 8, 12, 6)
        sleep = build(:sleep, user: user, slept_at: slept_at, waked_at: waked_at)
        expect(sleep.valid?).to eq true
      end
    end
  end
end
