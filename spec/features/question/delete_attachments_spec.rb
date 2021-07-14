require 'rails_helper'

feature 'User can delete attachments from question' do
  given(:user) { create :user }
  given!(:question) do
    create :question, author: user,
                      files: [fixture_file_upload('spec/rails_helper.rb'), fixture_file_upload('spec/spec_helper.rb')]
  end

  given(:another_question) { create :question, files: [fixture_file_upload('spec/rails_helper.rb')] }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

   scenario 'removes specific attached file' do
     visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      within "#attachment-id-#{question.files.first.id}" do
        click_on 'Delete attachment'
      end

      expect(page).not_to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "tries to delete files of another user's question" do
      visit question_path(another_question)
      within "#attachment-id-#{another_question.files.first.id}" do
        expect(page).to have_no_link "Delete attachment"
      end
    end
  end

  scenario 'Unauthenticated user cannot remove file from questions' do
    visit question_path(question)
    within "#attachment-id-#{question.files.first.id}" do
      expect(page).to have_no_link "Delete attachment"
    end
  end
end
