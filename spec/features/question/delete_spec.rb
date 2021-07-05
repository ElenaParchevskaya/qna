require 'rails_helper'

feature 'User can delete question' do
  describe 'authenticated user' do
    describe 'is author of question' do
      given(:user) { create(:user, :with_question) }

      background do
        sign_in(user)
        visit question_path(user.questions.first)
      end

      scenario 'should delete' do
        expect(page).to have_content(user.questions.first.body)
        click_on('Delete question')
        expect(page).to have_content('Your question successfully deleted.')
      end
    end

    describe 'is not author of question' do
      given(:user) { create(:user) }
      given(:question) { create(:question) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should not delete' do
        expect(page).not_to have_content('Delete question')
      end
    end
  end

  describe 'unauthenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'can`t delete question' do
      visit question_path(question)
      expect(page).not_to have_content('Delete question')
    end
  end
end
