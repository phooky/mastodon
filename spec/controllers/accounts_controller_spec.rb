require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  render_views

  let(:mus)  { Fabricate(:account, username: 'mus') }

  describe 'GET #show' do
    before do
      status1 = Status.create!(account: mus, text: 'Hello world')
      Status.create!(account: mus, text: 'Boop', thread: status1)
      status3 = Status.create!(account: mus, text: 'Picture!')
      status3.media_attachments.create!(account: mus, file: fixture_file_upload('files/attachment.jpg', 'image/jpeg'))
      Status.create!(account: mus, text: 'Mentioning @mus')
    end

    context 'atom' do
      before do
        get :show, params: { username: mus.username }, format: 'atom'
      end

      it 'returns http success with Atom' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'activitystreams2' do
      before do
        get :show, params: { username: mus.username }, format: 'activitystreams2'
      end

      it 'returns http success with Activity Streams 2.0' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'html' do
      before do
        get :show, params: { username: mus.username }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #followers' do
    it 'returns http success' do
      get :followers, params: { username: mus.username }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #following' do
    it 'returns http success' do
      get :following, params: { username: mus.username }
      expect(response).to have_http_status(:success)
    end
  end
end
