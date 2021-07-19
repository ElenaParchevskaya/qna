require 'rails_helper'

feature 'User can remove links from his question' do
  given(:user) { create :user }
  given(:answer) { create :answer, author: user }
  given!(:links) { create_list :link, 2, linkable: answer }
  given(:another_answer) { create :answer }
  given!(:another_link) { create :link, linkable: another_answer }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'removes specific link from his answer' do
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_link links.first.name
        expect(page).to have_link links.second.name
      end

      within "#link-#{links.first.id}" do
        click_on 'Delete link'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_no_link links.first.name
        expect(page).to have_link links.second.name
      end
    end

    scenario "tries to delete link of another user's answer" do
      visit question_path(another_answer.question)
      within "#link-#{another_link.id}" do
        expect(page).to have_no_link "Delete link"
      end
    end
  end

  scenario 'Unauthenticated user cannot remove links from answers' do
    visit question_path(answer.question)
    within "#link-#{links.first.id}" do
      expect(page).to have_no_link "Delete link"
    end
  end
end
