require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #github' do
    let(:oauth_data) { { provider: 'github', uid: '12345' } }
    let(:service) { instance_double('FindForOauthService') }

    before { allow(FindForOauthService).to receive(:new).and_return(service) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
      expect(service).to receive(:call)
      get :github
    end

    context 'user exists' do
      let!(:user) { create :user }

      before do
        allow(service).to receive(:call).and_return(user)
        get :github
      end

      it 'logins user' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user not exist' do
      before do
        allow(service).to receive(:call)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).not_to be
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user not persisted' do
      let!(:user) { build :user }

      before do
        allow(service).to receive(:call).and_return(user)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).not_to be
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
