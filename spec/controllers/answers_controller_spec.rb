require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      subject(:request) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :without_question) }
      end

      it 'saves answer in the database' do
        expect { request }.to change(question.answers, :count).by(1)
      end

      it 'renders :show view' do
        request
        expect(response).to render_template :show
      end
    end

    context 'with invalid attrubutes' do
      subject(:request) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save answer in the database' do
        expect { request }.not_to change(Answer, :count)
      end

      it 'renders :new view' do
        request
        expect(response).to render_template :new
      end
    end
  end
end
