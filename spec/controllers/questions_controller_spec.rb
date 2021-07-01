require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { request }.to change(Question, :count).by(1)
      end

      it 'renders to show view' do
        request
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      subject(:request) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do

        expect { request }.not_to change(Question, :count)
      end

      it 'renders new view' do
        request
        expect(response).to render_template :new
      end
    end
  end
end
