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
  end

  describe 'PATCH #update' do
    context 'when user is the author of answer' do
      let!(:answer) { create(:answer, author: user) }

      context 'with valid attributes' do
        subject(:http_request) do
          patch :update, params: { id: answer, answer: { body: 'New Answer' } }, format: :js
        end

        it 'changes answer attributes' do
          http_request
          answer.reload
          expect(answer.body).to eq 'New Answer'
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        subject(:http_request) do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end

        it 'does not change answer attributes' do
          expect { http_request }.not_to change(answer, :body)
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end
    end

    context 'when user is not the author of answer' do
      subject(:http_request) do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      before { answer }

      it 'does not change answer attributes' do
        expect { http_request }.not_to change(answer, :body)
      end
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
        expect(question.best_answer_id).to eq nil
      end

      it 'renders mark_best view' do
        http_request
        expect(flash[:notice]).to eq 'You must be the author to mark the answer as best.'
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

      it 'renders :destroy view' do
        http_request
        expect(response).to render_template :destroy
      end
    end
  end
end
