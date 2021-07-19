class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable, only: :create

  def create
    vote = @votable.votes.build(user: current_user, status: params[:status])
    if vote.save
      render json: { vote: vote, rating: @votable.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    vote = Vote.find(params[:id])
    if current_user.author_of?(vote)
      vote.destroy!
      render json: { vote: vote, rating: vote.votable.rating }, status: :ok
    else
      head :forbidden
    end
  end

  private

  def find_votable
    @votable = params[:votable_type].classify.constantize.find(params[:votable_id])
  end
end
