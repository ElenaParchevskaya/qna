require 'rails_helper'

feature 'Guest can view vote rating of question' do
  given(:user) { create :user }
  given(:question) { create :question }

  describe 'When there are no votes for question' do
    scenario 'User view zero rating of question' do
      visit question_path(question)
      within '.question' do
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  describe 'When there are some votes for question' do
    given!(:like_votes) { create_list :vote, 3, :like, votable: question }
    given!(:dislike_votes) { create_list :vote, 1, :dislike, votable: question }

    scenario 'User view right rating of question' do
      visit question_path(question)
      within '.question' do
        expect(page).to have_content 'Rating: 2'
      end
    end
  end
end
