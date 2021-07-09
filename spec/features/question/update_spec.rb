require 'rails_helper'

feature 'User can update question' do
  describe 'authenticated user' do
    describe 'is author of question' do
      given(:question) { create(:question) }
      given(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should update', js: true do
        click_on 'Edit question'

        within "#question-#{question.id}" do
          fill_in 'Body', with: 'Edited Question'
          click_on 'Edit'
        end
        expect(page).not_to have_link 'Edit', exact: true
        expect(page).to have_content 'Edited Question'
      end

      scenario 'updates a question with errors', js: true do
        click_on 'Edit question'

        within "#question-#{question.id}" do
          fill_in 'Body', with: nil
          click_on 'Edit'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'is not author of question' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should not update', js: true do
        within "#question-#{question.id}" do
          expect(page).not_to have_link 'Edit question'
        end
      end
    end
  end
end
