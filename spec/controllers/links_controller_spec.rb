require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create :user }

  describe 'DELETE #destroy' do
    describe 'question link' do
      subject(:delete_request) { delete :destroy, params: { id: link, format: :js } }

      let(:question) { create :question, author: user }
      let(:link) { create :link, linkable: question }
      let(:another_question) { create :question }
      let(:another_question_link) { create :link, linkable: another_question }

      describe 'by authenticated user' do
        before { login(user) }

        context 'when his question' do
          it 'removes link from question' do
            expect(question.links).to eq [link]
            delete_request
            expect(question.links.reload).to be_empty
          end

          it { is_expected.to render_template(:destroy) }
        end

        context 'when another user`s question' do
          subject! { delete :destroy, params: { id: another_question_link, format: :js } }

          it 'does not remove link from question' do
            expect(another_question.links).to eq [another_question_link]
          end

          it 'return error message' do
            expect(flash[:notice]).to eq 'You must be the author to delete the link.'
          end
        end
      end

      describe 'by unauthenticated user' do
        before { delete_request }

        it 'does not remove link from question' do
          expect(question.links).to eq [link]
        end

        it 'return unauthorized status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'answer link' do
      subject(:delete_request) { delete :destroy, params: { id: link, format: :js } }

      let(:answer) { create :answer, author: user }
      let(:link) { create :link, linkable: answer }
      let(:another_answer) { create :answer }
      let(:another_answer_link) { create :link, linkable: another_answer }

      describe 'by authenticated user' do
        before { login(user) }

        context 'when his answer' do
          it 'removes link from answer' do
            expect(answer.links).to eq [link]
            delete_request
            expect(answer.links.reload).to be_empty
          end

          it { is_expected.to render_template(:destroy) }
        end

        context 'when another user`s answer' do
          subject! { delete :destroy, params: { id: another_answer_link, format: :js } }
          it 'does not remove link from answer' do
            expect(another_answer.links).to eq [another_answer_link]
          end

          it 'return error message' do
            expect(flash[:notice]).to eq 'You must be the author to delete the link.'
          end
        end
      end

      describe 'by unauthenticated user' do
        before { delete_request }

        it 'does not remove link from answer' do
          expect(answer.links).to eq [link]
        end

        it 'return unauthorized status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
