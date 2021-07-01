require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'CET #index' do
    let!(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index views' do
      expect(response).to render_template :index
    end
  end

  describe 'CET #show' do
    before { get :show, params: { id: question} }

    it 'assigns thw request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'CET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET @edit' do
    before { get :edit, params: { id: question} }

    it 'assigns thw request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
end
