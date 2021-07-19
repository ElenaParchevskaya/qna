require 'rails_helper'

feature 'Authenticated user can add vote to the answer' do
  given(:user) { create :user }
  given(:answer) { create :answer }
  given(:user_answer) { create :answer, author: user }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'votes for another users answer' do
      background do
        visit question_path(answer.question)
      end

      describe 'as like' do
        scenario 'view string you like it instead vote links' do
          within "#answer-#{answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Like'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You like it!'
          end
        end

        scenario 'view the rating change' do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Like'
            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      describe 'as dislike' do
        scenario 'and view string you dislike it instead vote links' do
          within "#answer-#{answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Dislike'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You dislike it!'
          end
        end

        scenario 'and view the rating change' do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Dislike'
            expect(page).to have_content 'Rating: -1'
          end
        end
      end
    end

    describe 'when tries to vote for his answer' do
      background { visit question_path(user_answer.question) }

      scenario 'doesnt view any like or dislike links' do
        within "#answer-#{user_answer.id}" do
          expect(page).to have_no_link 'Like'
          expect(page).to have_no_link 'Dislike'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(answer.question) }

    scenario 'doesnt view any like or dislike links' do
      within "#answer-#{answer.id}" do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end
end
