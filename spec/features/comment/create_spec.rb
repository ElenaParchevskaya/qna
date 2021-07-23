require 'rails_helper'

feature 'User can create comment for question or answer', js: true do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:other_question) { create :question }

  describe 'Authenticated user' do
    background { sign_in(user) }

    describe 'for question' do
      background { visit question_path(question) }

      scenario 'creates comment' do
        within "#question-#{question.id}-comments" do
          expect(page).not_to have_content 'Text of comment'
          fill_in 'New comment', with: 'Text of comment'
          click_on 'Add comment'
          expect(page).to have_content 'Text of comment'
          expect(find('#comment_body').value).to be_empty
        end
      end

      scenario 'creates comment in multiple sessions' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('other_question') do
          visit question_path(other_question)
        end

        Capybara.using_session('user') do
          within "#question-#{question.id}-comments" do
            fill_in 'New comment', with: 'Text of comment'
            click_on 'Add comment'
          end
        end

          Capybara.using_session('guest') do
          within "#question-#{question.id}-comments" do
            expect(page).to have_content 'Text of comment'
          end
        end

        Capybara.using_session('other_question') do
          within "#question-#{other_question.id}-comments" do
            expect(page).not_to have_content 'Text of comment'
          end
        end
      end
    end

    describe 'for answer' do
      given!(:answer) { create :answer, question: question }
      given!(:other_answer) { create :answer, question: question }

      background do
        visit question_path(question)
      end

      scenario 'creates comment' do
        within "#answer-#{answer.id}-comments" do
          expect(page).not_to have_content 'Text of comment'
          fill_in 'New comment', with: 'Text of comment'
          click_on 'Add comment'
          expect(page).to have_content 'Text of comment'
          expect(find('#comment_body').value).to be_empty
        end

        within "#answer-#{other_answer.id}-comments" do
          expect(page).not_to have_content 'Text of comment'
        end
      end

      scenario 'creates comment in multiple sessions' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within "#answer-#{answer.id}-comments" do
            fill_in 'New comment', with: 'Text of comment'
            click_on 'Add comment'
          end
        end

        Capybara.using_session('guest') do
          within "#answer-#{answer.id}-comments" do
            expect(page).to have_content 'Text of comment'
          end
          within "#question-#{question.id}-comments" do
            expect(page).not_to have_content 'Text of comment'
          end
        end
      end
    end
  end

  describe 'Guest' do
    background { visit question_path(question) }

    scenario 'can not add comment for question or answer' do
      expect(page).not_to have_link 'Add comment'
      expect(page).not_to have_content 'New comment'
    end
  end
end
