require 'rails_helper'

feature 'Authenticated user can add vote to the question' do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:user_question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'votes for another user question' do
      background do
        visit question_path(question)
      end

      describe 'as like' do
        scenario 'and view string you like it instead vote links' do
          within ".question" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Like'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You like it!'
          end
        end

        scenario 'and view the rating change' do
          within ".question" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Like'
            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      describe 'as dislike' do
        scenario 'and view string you dislike it instead vote links' do
          within ".question" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Dislike'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You dislike it!'
          end
        end

        scenario 'and view the rating change' do
          within ".question" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Dislike'
            expect(page).to have_content 'Rating: -1'
          end
        end
      end
    end

    describe 'when tries to vote for his question' do
      background { visit question_path(user_question) }

      scenario 'doesnt view any like or dislike links' do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'doesnt view any like or dislike links' do
      expect(page).to have_no_link 'Like'
      expect(page).to have_no_link 'Dislike'
    end
  end
end
