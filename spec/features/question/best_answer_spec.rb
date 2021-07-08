require 'rails_helper'

feature 'User can mark answer as best', js: true do
  describe 'authenticated user' do
    given(:question) { create(:question) }
    given(:user) { question.author }
    given!(:answer1) { create(:answer, question: question) }
    given!(:answer2) { create(:answer, question: question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'marks as best' do
      within all('.answer').last do
        click_on('Best answer')
      end

      expect(page).to have_content 'Best!'
      expect(first('.answers')).to have_content answer2.body
    end
  end

  describe 'unauthenticated user' do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'does not mark as best' do
      expect(page).not_to have_content 'Best answer'
    end
  end
end
