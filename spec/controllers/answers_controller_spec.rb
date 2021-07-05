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
        post :create, params: { question_id: question, answer: attributes_for(:answer, :without_question) }
      end

      it 'saves answer in the database' do
        expect { http_request }.to change(Answer, :count).by(1)
      end

      it 'redirect to question`s :show view' do
        http_request
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attrubutes' do
      subject(:http_request) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save answer in the database' do
        expect { http_request }.not_to change(Answer, :count)
      end

      it 'renders question`s :show view' do
        http_request
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: answer } }

    context 'when user is the author of answer' do
      let!(:answer) { create(:answer, author: user) }

      it 'destroys answer from the database' do
        expect { http_request }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question`s show' do
        http_request
        expect(response).to redirect_to answer.question
      end
    end

    context 'when user is not the author of answer' do
      before { answer }

      it 'does not destroy answer from the database' do
        expect { http_request }.not_to change(Answer, :count)
      end

      it 'redirect to question`s show' do
        http_request
        expect(response).to redirect_to answer.question
      end
    end
  end
end
