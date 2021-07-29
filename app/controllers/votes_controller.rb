class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable, only: :create
  before_action :find_vote, only: :destroy

  def create
    authorize! :create_vote, @votable

    vote = @votable.votes.build(user: current_user, status: params[:status])
    if vote.save
      render json: { vote: vote, rating: @votable.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @vote
    @vote.destroy!
    render json: { vote: @vote, rating: @vote.votable.rating }, status: :ok
  end

  private

  def find_votable
    @votable = params[:votable_type].classify.constantize.find(params[:votable_id])
  end

  def find_vote
    @vote = Vote.find(params[:id])
  end
end
