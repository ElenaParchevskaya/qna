require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #edit' do
    let!(:user) { create :user }

    describe 'with valid authorization params' do
      let!(:authorization) { create :authorization, user: user }

      before { get :edit, params: { provider: authorization.provider, uid: authorization.uid } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end

      it 'initializes user instance var by authentication' do
        expect(assigns(:user)).to eq user
      end
    end

    describe 'with invalid authorization params' do
      it 'raises not found error' do
        expect { get :edit, params: { provider: 'provider', uid: 'uid' } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create :user }

    describe 'with valid authorization params and email' do
      subject(:http_request) do
        patch :update, params: { provider: authorization.provider, uid: authorization.uid, email: 'new@email.com' }
      end

      let!(:authorization) { create :authorization, user: user }

      it 'updates user email' do
        http_request
        expect(user.reload.email).to eq 'new@email.com'
      end

      it { is_expected.to redirect_to(root_path) }

      it 'sends confirmation email' do
        expect { http_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    describe 'with valid authorization params and invalid email' do
      subject(:http_request) do
        patch :update, params: { provider: authorization.provider, uid: authorization.uid, email: '' }
      end

      let!(:authorization) { create :authorization, user: user }

      it 'does not update user email' do
        http_request
        expect(user.reload.email).to eq user.email
      end

      it { is_expected.to render_template(:edit) }

      it 'does not send confirmation email' do
        expect { http_request }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end

    describe 'with invalid authorization params' do
      subject(:http_request) do
        get :edit, params: { provider: 'provider', uid: 'uid' }
      end

      it 'raises not found error' do
        expect { http_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
