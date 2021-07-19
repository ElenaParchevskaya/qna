require 'rails_helper'

feature 'Guest can view vote rating of answer' do
  given(:user) { create :user }
  given(:answer) { create :answer }

  describe 'When there are no votes for answer' do
    scenario 'User view zero rating answer' do
      visit question_path(answer.question)
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  describe 'When there are some votes for answer' do
    given!(:like_votes) { create_list :vote, 2, :like, votable: answer }
    given!(:dislike_votes) { create_list :vote, 1, :dislike, votable: answer }

    scenario 'User view right rating of answer' do
      visit question_path(answer.question)
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 1'
      end
    end
  end
end
