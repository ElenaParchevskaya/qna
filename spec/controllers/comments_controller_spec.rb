require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }

  describe 'POST #create' do
    let(:last_comment) { Comment.order(:create_at).last }

    context 'for question' do
      subject(:http_request) do
        post :create,
             params: { commentable_type: question.class, commentable_id: question.id, comment: { body: 'My comment' } }, format: :js
      end

      let(:question) { create :question }

      describe 'by authenticate user' do
        before { login(user) }

        context 'with valid params' do
          it 'create new comment for question' do
            expect { http_request }.to change { question.comments.count }.by(1)
          end

          it { should render_template(:create) }

          it 'broadcast new comment to channel' do
            expect { http_request }.to have_broadcasted_to(question)
            .with(a_hash_including(commentable_id: question.id))
            .from_channel(QuestionChannel)
          end
        end

        context 'with invalid params' do
          subject(:http_request) do
            post :create, params: { commentable_type: question.class, commentable_id: question.id, comment: { body: ' ' } },
                          format: :js
          end

          it 'does not create new comment' do
            expect { http_request }.not_to change(Comment, :count)
          end

          it 'does not broadcast new comment to channel' do
            expect { http_request }.not_to have_broadcasted_to(question).from_channel(QuestionChannel)
          end

          it { is_expected.to render_template(:create) }
        end
      end

      describe 'by unauthenticated user' do
        it 'does not broadcast new comment to channel' do
          expect { http_request }.not_to have_broadcasted_to(question).from_channel(QuestionChannel)
        end

        it 'return unauthorized status' do
          http_request
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'for answer' do
      subject(:http_request) do
        post :create, params: { commentable_type: answer.class, commentable_id: answer.id, comment: { body: 'My comment' } },
                      format: :js
      end

      let(:answer) { create :answer }

      describe 'by authenticated user' do
        before { login(user) }

        context 'with valid params' do
          it 'creates new comment for answer' do
            expect { http_request }.to change { answer.comments.count }.by(1)
          end

          it { should render_template(:create) }

          it 'broadcast new comment to channel' do
            expect { http_request }.to have_broadcasted_to(answer.question)
              .with(a_hash_including(commentable_id: answer.id))
               .from_channel(QuestionChannel)
          end
        end

        context 'with invalid params' do
          subject(:http_request) do
            post :create, params: { commentable_type: answer.class, commentable_id: answer.id, comment: { body: ' ' } },
                          format: :js
          end

          it 'does not create new comment' do
            expect { http_request }.not_to change(Comment, :count)
          end

          it 'does not broadcast new comment to channel' do
            expect { http_request }.not_to have_broadcasted_to(answer.question).from_channel(QuestionChannel)
          end

          it { is_expected.to render_template(:create) }
        end
      end

      describe 'by unauthenticated user' do
        it 'does not create new comment' do
          expect { http_request }.not_to change(Comment, :count)
        end

        it 'does not broadcast new comment to channel' do
          expect { http_request }.not_to have_broadcasted_to(answer.question).from_channel(QuestionChannel)
        end

        it 'returns unauthorized status' do
          http_request
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
