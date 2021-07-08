require 'rails_helper'

feature 'User can create answer for question on the question`s show page' do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid parameters', js: true do
      fill_in 'Body', with: 'Some text'
      click_on 'Answer'

      expect(page).to have_content('Your answer successfully created.')
      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.answers' do
        expect(page).to have_content('Some text')
      end
    end

    scenario 'with invalid parameters', js: true do
      click_on 'Answer'
      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'can not create answer for question' do
      visit question_path(question)
      expect(page).to have_content('You need to be signed in to answer questions')
    end
  end
end
