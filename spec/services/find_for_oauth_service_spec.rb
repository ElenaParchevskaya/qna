require 'rails_helper'

RSpec.describe FindForOauthService do
  subject(:server) { described_class.new(auth) }

  let!(:user) { create :user }
  let(:base_auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

  context 'user already has authorization' do
    let(:auth) { base_auth }

    before { user.authorizations.create!(provider: auth.provider, uid: auth.uid) }

    it 'returns the user' do
      expect(server.call).to eq user
    end

    it 'does not create new user' do
      expect { server.call }.not_to change(User, :count)
    end

    it 'does not create new authorization' do
      expect { server.call }.not_to change(Authorization, :count)
    end
  end

  context 'user has no authorization' do
    let(:auth) { base_auth.merge(info: { email: user.email }) }

    context 'user exists' do
      it 'does not create new user' do
        expect { server.call }.not_to change(User, :count)
      end

      it 'creates authorization for user' do
        expect { server.call }.to change(Authorization, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        user = server.call
        last_authorization = user.authorizations.order(:created_at).last
        expect(last_authorization.provider).to eq auth.provider
        expect(last_authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(server.call).to eq user
      end
    end

    context 'user does not exist' do
      context 'when auth has email' do
        let(:auth) { base_auth.merge(info: { email: 'newuser@email.com' }) }

        it 'does create new user' do
          expect { server.call }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(server.call).to be_a(User)
        end

        it 'returns confirmed user' do
          expect(server.call).to be_confirmed
        end

        it 'fills email for new user' do
          expect(server.call.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = server.call
          expect(user.authorizations.count).to eq 1
        end

        it 'creates authorization with provider and uid' do
          user = server.call
          last_authorization = user.authorizations.order(:created_at).last
          expect(last_authorization.provider).to eq auth.provider
          expect(last_authorization.uid).to eq auth.uid
        end
      end

      context 'when auth has no email' do
        let(:auth) { base_auth.merge(info: {}) }

        it 'does create new user' do
          expect { server.call }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(server.call).to be_a(User)
        end

        it 'returns unconfirmed user' do
          expect(server.call).not_to be_confirmed
        end

        it 'returns invalid user without email' do
          expect(server.call.email).not_to be_present
        end

        it 'creates authorization for user' do
          user = server.call
          expect(user.authorizations.count).to eq 1
        end

        it 'creates authorization with provider and uid' do
          user = server.call
          last_authorization = user.authorizations.order(:created_at).last
          expect(last_authorization.provider).to eq auth.provider
          expect(last_authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
