require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    subject(:http_request) { post :create, params: { question_id: question }, format: :js }

    let!(:question) { create :question }

    context 'when authenticated user' do
      let(:user) { create :user }

      before { login(user) }

      it 'creates new subscription for question' do
        expect { http_request }.to change { question.subscriptions.count }.by(1)
      end

      it 'creates new subscription for user' do
        expect { http_request }.to change { user.subscriptions.count }.by(1)
      end

      it { is_expected.to render_template(:create) }

      context 'when subscription is present for user and question' do
        before { question.subscriptions.create!(user: user) }

        it 'does not create new subscription' do
          expect { http_request }.not_to change(Subscription, :count)
        end

        it { is_expected.to render_template(:create) }
      end
    end

    context 'when unauthenticated user' do
      it 'does not create new subscription' do
        expect { http_request }.not_to change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { question_id: question.id }, format: :js }

    let!(:question) { create :question }

    context 'when authenticated user' do
      let(:user) { create :user }

      before { login(user) }

      context 'when subscription is present for user and question' do
        before { question.subscriptions.create!(user: user) }

        it 'destroys the subscription for question' do
          expect { http_request }.to change { question.subscriptions.count }.by(-1)
        end

        it 'destroys the subscription for user' do
          expect { http_request }.to change { user.subscriptions.count }.by(-1)
        end

        it { is_expected.to render_template(:destroy) }
      end

      context 'when no subscriptions for user and question' do
        it 'does not change subscriptions count' do
          expect { http_request }.not_to change(Subscription, :count)
        end

        it { is_expected.to render_template(:destroy) }
      end
    end

    context 'when unauthenticated user' do
      it 'does not change subscriptions count' do
        expect { http_request }.not_to change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
