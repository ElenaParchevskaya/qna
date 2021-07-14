require 'rails_helper'

feature 'User can remove links from his question' do
  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given!(:links) { create_list :link, 2, linkable: question }
  given(:another_question) { create :question }
  given!(:another_link) { create :link, linkable: another_question }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'removes specific link from his question' do
      visit question_path(question)

      expect(page).to have_link links.first.name
      expect(page).to have_link links.second.name

      within "#link-#{links.first.id}" do
        click_on 'Delete link'
      end

      expect(page).to have_no_link links.first.name
      expect(page).to have_link links.second.name
    end

    scenario "tries to delete link of another user's question" do
      visit question_path(another_question)
      within "#link-#{another_link.id}" do
        expect(page).to have_no_link "Delete link"
      end
    end
  end

  scenario 'Unauthenticated user cannot remove links from questions' do
    visit question_path(question)
    within "#link-#{links.first.id}" do
      expect(page).to have_no_link "Delete link"
    end
  end
end
