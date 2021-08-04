require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:me) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: me.id }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user_json) { json }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields of user' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private files for user' do
        %w[password encrypted_password].each do |attr|
          expect(user_json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:me) { create :user }
    let!(:users) { create_list :user, 2 }
    let(:access_token) { create :access_token, resource_owner_id: me.id }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users_json) { json }
      let(:user_json) { users_json.first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns list of users' do
        expect(users_json.size).to eq users.size
      end

      it 'returns all users without me' do
        json_user_ids = users_json.map { |user_json| user_json['id'] }
        expect(json_user_ids.sort).to eq(users.map(&:id).sort)
      end

      it 'returns public fields of user' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_json[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'doesn`t return private fields of user' do
         %w[password encrypted_password].each do |attr|
          expect(user_json).not_to have_key(attr)
        end
      end
    end
  end
end
