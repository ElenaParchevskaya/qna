require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

   it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders :new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      subject(:http_request) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :without_question) }, format: :js
      end

      it 'saves answer in the database' do
        expect { http_request }.to change(Answer, :count).by(1)
      end

      it 'renders :create view' do
        http_request
        expect(response).to render_template :create
      end
    end

    context 'with invalid attrubutes' do
      subject(:http_request) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'does not save answer in the database' do
        expect { http_request }.not_to change(Answer, :count)
      end

      it 'renders :create view' do
        http_request
        expect(response).to render_template :create
      end
    end

    context 'with attached files' do
      let(:last_answer) { Answer.order(:created_at).last }

      it 'attaches files to answer' do
        post :create,
             params: {
                question_id: question.id,
                answer: { body: 'Body', files: [fixture_file_upload('spec/spec_helper.rb')] },
                format: :js }
        expect(Answer.last.files).to be_attached
        expect(last_answer.files).to be_attached
      end
    end

    context 'with links' do
      context 'when links is valid' do
        let(:last_answer) { Answer.order(:created_at).last }

        it 'adds links to answer' do
          post :create,
               params: { question_id: question.id,
                         answer: { body: 'Body',
                                    links_attributes: {
                                      0 => { name: 'Thinknetica', url: 'https://thinknetica.com' },
                                      1 => { name: 'Wiki', url: 'https://www.wikipedia.org' }
                                    } }, format: :js }
          expect(last_answer.links.pluck(:name).sort).to eq %w[ Thinknetica Wiki]
          expect(last_answer.links.pluck(:url).sort).to eq ['https://thinknetica.com', 'https://www.wikipedia.org']
        end
      end

      context 'when links is not valid' do
        subject do
          post :create,
               params: {
                  question_id: question.id,
                  answer: { body: 'Body', links_attributes: { 0 => { url: 'https://thinknetica.com' } } },
                  format: :js }
        end

        it 'does not create new answer' do
          expect { subject }.not_to change(Answer, :count)
        end

        it { is_expected.to render_template(:create) }
      end
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'update resource' do
      let!(:resource) { create :answer, question: question, author: user }
      let(:update_attributes) { { body: 'Edited answer' } }
      let(:invalid_attributes) { { body: ' ' } }
    end
  end

  describe 'PATCH #mark_best' do
    subject(:http_request) do
      patch :mark_best, params: { id: answer }, format: :js
    end

    context 'when user is the author of question' do
      let(:question) { create(:question, :with_answers, author: user) }
      let(:answer) { question.answers.first }

      it 'has best answer' do
        http_request
        expect(question.reload.best_answer_id).to eq answer.id
      end

      it 'renders :mark_best view' do
        http_request
        expect(response).to render_template :mark_best
      end
    end

    context 'when user is not the author of question' do
      let(:question) { create(:question, :with_answers) }
      let(:answer) { question.answers.first }

      it 'has best answer' do
        http_request
        expect(question.reload.best_answer_id).to eq nil
      end

      it 'return forbidden status' do
        http_request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'when user is the author of answer' do
      let!(:answer) { create(:answer, author: user) }

      it 'destroys answer from the database' do
        expect { http_request }.to change(Answer, :count).by(-1)
      end

      it 'renders :destroy view' do
        http_request
        expect(response).to render_template :destroy
      end
    end

    context 'when user is not the author of answer' do
      before { answer }

      it 'does not destroy answer from the database' do
        expect { http_request }.not_to change(Answer, :count)
      end

      it 'return forbidden status' do
        http_request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
