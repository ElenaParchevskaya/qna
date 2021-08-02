require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'when question attachment' do
      subject(:delete_request) { delete :destroy, params: { id: question.files.first, format: :js } }

      let(:question) { create(:question, files: [fixture_file_upload('spec/spec_helper.rb')]) }
      let(:user) { create(:user) }

      before { login(user) }

      context 'when user is the author of question' do
        let!(:question) { create(:question, author: user, files: [fixture_file_upload('spec/spec_helper.rb')]) }

        it 'removes file from question' do
          delete_request
          expect(question.reload.files).not_to be_attached
        end

        it { is_expected.to render_template(:destroy) }
      end

      context 'when user isn`t the author of question' do
        before { delete_request }

        it 'does not remove file from question' do
          expect(question.reload.files).to be_attached
        end

        it 'return forbidden status' do
          delete_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when answer attachment' do
      subject(:delete_request) { delete :destroy, params: { id: answer.files.first, format: :js } }

      let(:answer) { create(:answer, files: [fixture_file_upload('spec/spec_helper.rb')]) }
      let(:user) { create(:user) }

      before { login(user) }

      context 'when user is the author of answer' do
        let!(:answer) { create(:answer, author: user, files: [fixture_file_upload('spec/spec_helper.rb')]) }

        it 'removes file from answer' do
          delete_request
          expect(answer.reload.files).not_to be_attached
        end

        it { is_expected.to render_template(:destroy) }
      end

      context 'when user isn`t the author of answer' do
        before { delete_request }

        it 'does not remove file from answer' do
          expect(answer.reload.files).to be_attached
        end

        it 'return forbidden status' do
          delete_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
