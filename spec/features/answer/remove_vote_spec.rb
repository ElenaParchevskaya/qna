require 'rails_helper'

feature 'Authenticated user can remove his vote to the answer' do
  given(:user) { create :user }
  given(:answer) { create :answer }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'for answer which liked before' do
      given!(:like_vote) { create :vote, :like, user: user, votable: answer }

      before { visit question_path(answer.question) }

      scenario 'removes vote' do
        within "#answer-#{answer.id}" do
          expect(page).to have_no_link 'Like'
          expect(page).to have_no_link 'Dislike'
          click_on 'Cancel'
          expect(page).to have_link 'Like'
          expect(page).to have_link 'Dislike'
          expect(page).to have_no_content 'You like it!'
        end
      end

      scenario 'and vote overwise' do
        within "#answer-#{answer.id}" do
          click_on 'Cancel'
          click_on 'Dislike'
          expect(page).to have_content 'You dislike it!'
        end
      end
    end

    describe 'for answer which disliked before' do
      given!(:dislike_vote) { create :vote, :dislike, user: user, votable: answer }

      before { visit question_path(answer.question) }

      scenario 'removes vote' do
        within "#answer-#{answer.id}" do
          expect(page).to have_no_link 'Like'
          expect(page).to have_no_link 'Dislike'
          click_on 'Cancel'
          expect(page).to have_link 'Like'
          expect(page).to have_link 'Dislike'
          expect(page).to have_no_content 'You dislike it!'
        end
      end

      scenario 'and vote overwise' do
        within "#answer-#{answer.id}" do
          click_on 'Cancel'
          click_on 'Like'
          expect(page).to have_content 'You like it!'
        end
      end
    end

    describe 'for answer which did not vote before' do
      background { visit question_path(answer.question) }

      scenario 'doesnt view cancel link' do
        within "#answer-#{answer.id}" do
          expect(page).to have_no_link 'Cancel'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(answer.question) }

    scenario 'doesnt view cancel link' do
      within "#answer-#{answer.id}" do
        expect(page).to have_no_link 'Cancel'
      end
    end
  end
end
