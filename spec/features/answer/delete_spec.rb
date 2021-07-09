require 'rails_helper'

feature 'User can delete answer' do
  describe 'Authenticated user' do
    describe 'is author of answer' do
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should delete', js: true do
        expect(page).to have_content(answer.body)

        click_on('Delete answer')

        expect(page).to have_content('Your answer successfully deleted.')
        expect(page).not_to have_content(answer.body)
      end
    end

    describe 'is not author of answer' do
      given(:user) { create(:user) }
      given(:answer) { create(:answer) }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should not delete', js: true do
        expect(page).not_to have_content('Delete answer')
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:user) { create(:user) }
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    scenario 'can`t delete answer', js: true do
      visit question_path(question)

      expect(page).not_to have_content('Delete answer')
    end
  end
end
