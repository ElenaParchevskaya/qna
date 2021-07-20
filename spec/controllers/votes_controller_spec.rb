require 'rails_helper'

 RSpec.describe VotesController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  describe 'POST #create' do
    subject(:http_request) do
      post :create, params: { votable_type: 'Question', votable_id: question.id, status: :like }, format: :json
    end

    describe 'by authenticated user' do
      before { login(user) }

      context 'when first vote' do
        it 'creates new vote for question' do
          expect { http_request }.to change { question.votes.count }.by(1)
        end

        it 'returns vote in json with created status' do
          http_request
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          vote = json_response['vote']
          rating = json_response['rating']
          expect(vote['status']).to eq 'like'
          expect(rating).to be_present
        end
      end

      context 'when second vote' do
        before { question.votes.create!(user: user) }

        it 'does not new vote for question and return error status' do
          expect { http_request }.not_to change(Vote, :count)
        end

        it 'returns errors in json with unprocessable entity status' do
          http_request
          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body)['errors']
          expect(errors).to eq ["User has already been taken"]
        end
      end

      context 'with invalid params' do
        subject(:http_request) do
          post :create, params: { votable_type: 'Question', votable_id: question.id, vote: { status: 0 } },
                         format: :json
        end

        it 'does not create new vote' do
          expect { http_request }.not_to change(Vote, :count)
        end

        it 'return errors in json with unprocessable entity-status' do
          http_request
          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body)['errors']
          expect(errors).to eq ["Status can't be blank"]
        end
      end
    end

    describe 'by unauthenticated user' do
      it 'does not create new vote' do
        expect { http_request }.not_to change(Vote, :count)
      end

      it 'return unauthorized status' do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: vote }, format: :json }

    let!(:vote) { create :vote, user: user, votable: question }
    let!(:another_user_vote) { create :vote, votable: question }

    describe 'by authenticated user' do
      before { login(user) }

      context 'when his own vote' do
        it 'destroys vote' do
          expect { http_request }.to change { question.votes.count }.by(-1)
        end

        it 'returns vote with votable information, rating and ok status' do
          http_request
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          vote_json = json_response['vote']
          rating = json_response['rating']
          expect(vote_json['votable_type']).to eq vote.votable_type
          expect(vote_json['votable_id']).to eq vote.votable_id
          expect(rating).to be_present
        end
      end

      context 'when another user`s vote' do
        subject(:http_request) { delete :destroy, params: { id: another_user_vote }, format: :json }

        it 'does not destroy vote' do
          expect { http_request }.not_to change(Vote, :count)
        end

        it 'return forbidden status' do
          http_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'by unauthenticated user' do
      it 'does not destroy vote' do
        expect { http_request }.not_to change(Vote, :count)
      end

      it 'return unauthorized status' do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
