require 'rails_helper'

feature 'User can search the user', sphinx: true, js: true do
  given!(:first_user) { create :user, email: 'one@email.com' }
  given!(:second_user) { create :user, email: 'two@email.com' }

  before { visit search_path }

  context 'User select user search checkbox' do
    before { check 'User' }

    scenario 'and searches the user by email' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_user.email
        expect(page).not_to have_content second_user.email

        fill_in 'Query', with: 'one@email.com'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_user.email
        expect(page).not_to have_content second_user.email

        fill_in 'Query', with: 'two@email.com'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).not_to have_content first_user.email
        expect(page).to have_content second_user.email

        fill_in 'Query', with: 'other@email.com'
        click_on 'Search'

        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_user.email
        expect(page).not_to have_content second_user.email
        expect(page).to have_content 'No entries found'
      end
    end

    context 'when there are any questions with coincident query' do
      given!(:question) { create :question, author: first_user }

      scenario 'and does not find questions' do
        ThinkingSphinx::Test.run do
          expect(page).not_to have_content question.title

          fill_in 'Query', with: first_user.email
          click_on 'Search'

          expect(page).not_to have_content question.title
        end
      end
    end
  end

  scenario 'User can not search users without user checkbox selected' do
    ThinkingSphinx::Test.run do
      fill_in 'Query', with: 'email'
      click_on 'Search'

      expect(page).to have_content 'You should choose type of results'
      expect(page).not_to have_content first_user.email
      expect(page).not_to have_content second_user.email
    end
  end
end
