describe API::V1::FeedAPI, type: :request do
  let!(:user) { create(:user, name: 'user1') }

  describe 'GET /api/v1/feeds' do
    let(:user2) { create(:user, name: 'user2') }
    let(:user3) { create(:user, name: 'user3') }
    let(:params) { { page: 1, per_page: 10 } }
    let(:slept_at) { Time.new(2019, 8, 10, 22) }
    let(:waked_at) { Time.new(2019, 8, 11, 6) }
    subject { get '/api/v1/feeds', params: params }

    it 'returns paginated sleeps from followed users, ordered by sleep length' do
      create(:following, user: user, followed_user: user2)
      sleep1 = create(:sleep, user: user2, slept_at: slept_at, waked_at: waked_at - 1.hour)
      sleep2 = create(
        :sleep,
        user: user2,
        slept_at: slept_at - 1.day,
        waked_at: waked_at - 1.day - 2.hour
      )
      create(:following, user: user, followed_user: user3)
      sleep3 = create(:sleep, user: user3, slept_at: slept_at, waked_at: waked_at)

      subject
      json_body = JSON.parse(response.body)
      result_ids = json_body['results'].map { |r| r['id'] }
      expect(result_ids).to eq [sleep3.id, sleep1.id, sleep2.id]
    end

    it 'won\'t returns sleep from unfollowed user' do
      create(:sleep, user: user2, slept_at: slept_at, waked_at: waked_at)

      subject
      json_body = JSON.parse(response.body)
      expect(json_body['results']).to eq []
    end

    it 'won\'t returns sleep which waked_at is nil' do
      create(:following, user: user, followed_user: user2)
      create(:sleep, user: user2, slept_at: slept_at, waked_at: nil)

      subject
      json_body = JSON.parse(response.body)
      expect(json_body['results']).to eq []
    end
  end
end
