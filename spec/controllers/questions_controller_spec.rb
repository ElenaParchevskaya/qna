require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    include_context 'gon'
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'set gon user id' do
      expect(gon['user_id']).to eq user.id
    end

    context 'when question has answers' do
      let!(:question) { create(:question, :with_answers) }

      it 'has array of answers' do
        expect(question.answers).to match_array Answer.all
      end
    end
  end

  describe 'GET #new' do
    before { get :new }
   it 'assigns a new Question to @question' do
     expect(assigns(:question)).to be_a_new(Question)
   end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has current user' do
      expect(controller.current_user).to eq user
    end
  end

  describe 'POST #create' do
    let(:last_question) { Question.order(:created_at).last }

    context 'with valid attrubutes' do
      subject(:http_request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { http_request }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        http_request
        expect(response).to redirect_to assigns(:question)
      end

      it 'broadcasts new question to channel' do
        expect { http_request }.to have_broadcasted_to("questions").with(last_question)
      end
    end

    context 'with invalid attrubutes' do
      subject(:http_request) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { http_request }.not_to change(Question, :count)
      end

      it 'renders :new view' do
        http_request
        expect(response).to render_template :new
      end
    end

    context 'with attached files' do
      let(:last_question) { Question.order(:created_at).last }

      it 'attaches files to question' do
        post :create,
             params: { question: { title: 'Title', body: 'Body', files: [fixture_file_upload('spec/spec_helper.rb')] } }
        expect(Question.last.files).to be_attached
        expect(last_question.files).to be_attached
      end
    end

    context 'with links' do
      context 'when links is valid' do
        let(:last_question) { Question.order(:created_at).last }

        it 'adds links to question' do
          post :create,
               params: { question: { title: 'Title', body: 'Body',
                                      links_attributes: {
                                        0 => { name: 'Thinknetica', url: 'https://thinknetica.com' },
                                        1 => { name: 'Wiki', url: 'https://www.wikipedia.org' }
                                      } } }
          expect(last_question.links.pluck(:name).sort).to eq %w[Thinknetica Wiki]
          expect(last_question.links.pluck(:url).sort).to eq ['https://thinknetica.com', 'https://www.wikipedia.org']
        end
      end

      context 'when links is not valid' do
        subject(:http_request) do
          post :create,
               params: { question: { title: 'Title', body: 'Body',
                                      links_attributes: { 0 => { url: 'https://thinknetica.com' } } } }
        end

        it 'does not create new question' do
          expect { http_request }.not_to change(Question, :count)
        end

        it { is_expected.to render_template(:new) }

        it 'does not broadcast to channel' do
          expect { http_request }.not_to have_broadcasted_to('questions')
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is the author of question' do
      let!(:question) { create(:question, author: user) }

      context 'with valid attributes' do
        subject(:http_request) do
          patch :update, params: { id: question, question: { body: 'New Question' } }, format: :js
        end

        it 'changes answer attributes' do
          http_request
          question.reload
          expect(question.body).to eq 'New Question'
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        subject(:http_request) do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end

        it 'does not change answer attributes' do
          expect { http_request }.not_to change(question, :body)
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end
    end

    context 'when user is not the author of question' do
      subject(:http_request) do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it 'does not change answer attributes' do
        expect { http_request }.not_to change(question, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: question } }

    context 'when user is the author of question' do
      let!(:question) { create(:question, author: user) }

      it 'destroys question from the database' do
        expect { http_request }.to change(Question, :count).by(-1)
      end

      it 'redirect to :index view' do
        http_request
        expect(response).to redirect_to questions_path
      end
    end

    context 'when user is not the author of question' do
      before { question }

      it 'does not destroy question from the database' do
        expect { http_request }.not_to change(Question, :count)
      end

       it 'return forbidden status' do
        http_request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
