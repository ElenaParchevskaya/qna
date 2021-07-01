require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
    let(:question) { create(:question) }

    before { get :show, params: { id: question} }

    it 'assigns thw request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders index show' do
      expect(response).to render_template :show
    end
  end
end
