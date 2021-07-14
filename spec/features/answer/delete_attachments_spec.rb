require 'rails_helper'

feature 'User can remove file from answer' do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) do
    create :answer, question: question, author: user,
                    files: [fixture_file_upload('spec/rails_helper.rb'), fixture_file_upload('spec/spec_helper.rb')]
  end
  given!(:another_answer) { create :answer, question: question, files: [fixture_file_upload('spec/rails_helper.rb')] }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'removes specific attached file' do
      within ".answers #answer-#{answer.id}" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      within "#attachment-id-#{answer.files.first.id}" do
        click_on 'Delete attachment'
      end

      within ".answers #answer-#{answer.id}" do
        expect(page).not_to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "tries to delete files of another user's answer" do
      within "#attachment-id-#{another_answer.files.first.id}" do
        expect(page).to have_no_link "Delete attachment"
      end
    end
  end

  scenario 'Unauthenticated user cannot remove file from answers' do
    visit question_path(question)
    within "#attachment-id-#{answer.files.first.id}" do
      expect(page).to have_no_link "Delete attachment"
    end
  end
end
