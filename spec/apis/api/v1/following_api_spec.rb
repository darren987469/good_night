describe API::V1::FollowingAPI, type: :request do
  let!(:user) { create(:user, name: 'user1') }

  describe 'POST /api/v1/followings' do
    let(:params) { { followed_user_id: followed_user.id } }
    subject { post '/api/v1/followings', params: params }

    context 'followed user doesn\'t exist' do
      let(:followed_user) { build(:user, id: -1) }

      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end

    context 'user follows self' do
      let(:followed_user) { user }

      it 'returns 400' do
        subject
        expect(response).to have_http_status 400
      end
    end

    context 'user has already followed other user' do
      let(:followed_user) { create(:user, name: 'user2') }
      let!(:following) { create(:following, user: user, followed_user: followed_user) }

      it 'returns 201' do
        subject
        expect(response).to have_http_status 201
        expected_body = Entity::V1::Following.represent(following).to_json
        expect(response.body).to eq expected_body
      end
    end

    context 'follow other user successfully' do
      let(:followed_user) { create(:user, name: 'user2') }

      it 'returns 201 and creates following record' do
        expect { subject }.to change { Following.count }.by(1)
        following = Following.last
        expect(following).to have_attributes(
          user_id: user.id,
          followed_user_id: followed_user.id
        )
        expect(response).to have_http_status 201
        expected_body = Entity::V1::Following.represent(following).to_json
        expect(response.body).to eq expected_body
      end
    end
  end

  describe 'DELETE /api/v1/followings' do
    let(:params) { { followed_user_id: followed_user.id } }
    subject { delete '/api/v1/followings', params: params }

    context 'user has already unfollowed (no following record)' do
      let(:followed_user) { build(:user, id: -1) }
      it 'returns 204' do
        subject
        expect(response).to have_http_status 204
      end
    end

    context 'user hasn\'t unfollowed (following record exists)' do
      let(:followed_user) { create(:user, name: 'name') }
      let!(:following) { create(:following, user: user, followed_user: followed_user) }

      it 'returns 204 and destroy the following record' do
        expect { subject }.to change { Following.count }.by(-1)
        expect(response).to have_http_status 204
      end
    end
  end
end
