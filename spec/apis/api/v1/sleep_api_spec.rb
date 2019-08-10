describe API::V1::SleepAPI, type: :request do
  let!(:user) { create(:user, name: 'user1') }

  describe 'GET /api/v1/sleeps' do
    let(:params) { { page: 1, per_page: 2 } }
    subject { get '/api/v1/sleeps', params: params }

    before do
      create(:sleep, user: user, slept_at: Time.new(2019, 8, 9, 22))
      create(:sleep, user: user, slept_at: Time.new(2019, 8, 10, 22))
      create(:sleep, user: user, slept_at: Time.new(2019, 8, 11, 22))
    end

    it 'returns 200 and paginated sleeps, ordered by slept_at desc' do
      subject

      sleeps = Sleep.page(params[:page]).per(params[:per_page]).order(slept_at: :desc)
      expect(response).to have_http_status 200
      expected_body = Entity::V1::PaginatedSleep.represent(sleeps).to_json
      expect(response.body).to eq expected_body
    end
  end

  describe 'POST /api/v1/sleeps' do
    let(:slept_at) { Time.new(2019, 8, 9, 22) }
    let(:params) { { slept_at: slept_at } }
    subject { post '/api/v1/sleeps', params: params }

    it 'returns 201 and creates sleep record' do
      expect { subject }.to change { Sleep.count }.by(1)
      sleep = Sleep.last
      expect(sleep).to have_attributes(
        user_id: user.id,
        slept_at: slept_at
      )
      expect(response).to have_http_status 201
      expect(response.body).to eq Entity::V1::Sleep.represent(sleep).to_json
    end

    context 'when required params slept_at missing' do
      let(:params) { {} }
      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end

    context 'when there is a sleep overlap' do
      let(:waked_at) { Time.new(2019, 8, 10, 6) }
      let(:params) { { slept_at: slept_at, waked_at: waked_at } }

      before { create(:sleep, user: user, slept_at: slept_at, waked_at: waked_at) }

      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end
  end

  describe 'PATCH /api/v1/sleeps/:id' do
    let(:slept_at) { Time.new(2019, 8, 9, 22) }
    let(:waked_at) { Time.new(2019, 8, 10, 6) }
    let(:sleep) do
      create(:sleep, user: user, slept_at: Time.new(2019, 8, 9, 21))
    end
    let(:params) { { slept_at: slept_at, waked_at: waked_at } }
    subject { patch "/api/v1/sleeps/#{sleep.id}", params: params }

    it 'returns 200 and updates sleep' do
      subject
      expect(sleep.reload).to have_attributes(
        slept_at: slept_at,
        waked_at: waked_at
      )
      expect(response).to have_http_status 200
      expect(response.body).to eq Entity::V1::Sleep.represent(sleep).to_json
    end

    context 'no params given' do
      let(:params) { {} }
      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end

    context 'when there is a sleep overlap' do
      before { create(:sleep, user: user, slept_at: slept_at, waked_at: waked_at) }

      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end
  end
end
