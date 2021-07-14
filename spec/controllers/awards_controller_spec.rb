require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create :user }

  describe 'GET #index' do
    subject(:http_request) { get :index }

    describe 'by authenticated user' do
      before { login(user) }

      it 'renders index view' do
        http_request
        expect(response).to render_template :index
      end
     end

    describe 'by unauthenticated user' do
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
