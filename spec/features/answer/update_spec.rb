require 'rails_helper'

feature 'User can update his answer' do
  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'is author of answer' do
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      scenario 'should update', js: true do
        click_on 'Edit answer'

        within ".answers #answer-#{answer.id}" do
          fill_in 'Body', with: 'Edited Answer'
        end
        click_on 'Edit'

        expect(page).not_to have_link 'Edit', exact: true
        expect(page).to have_content 'Edited Answer'
      end
    end

    describe "is not author of answer" do
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      scenario 'should not update', js: true do
        expect(page).not_to have_content 'Edited Answer'
      end
    end
  end

  describe "unauthenticated user" do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    background { visit question_path(question) }

    scenario 'can not update another answer', js: true do
      expect(page).not_to have_content 'Edited Answer'
    end
  end
end
