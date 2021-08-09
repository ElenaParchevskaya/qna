require 'sphinx_helper'

feature 'User can search the answer', sphinx: true, js: true do
  given!(:first_answer) { create :answer, body: 'One body' }
  given!(:second_answer) { create :answer, body: 'Two body' }

  before { visit search_path }

  context 'User select Answer search checkbox' do
    before { check 'Answer' }

    scenario 'and searches the answer by body' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_answer.body
        expect(page).not_to have_content second_answer.body

        fill_in 'Query', with: 'one'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_answer.body
        expect(page).not_to have_content second_answer.body

        fill_in 'Query', with: 'two'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).not_to have_content first_answer.body
        expect(page).to have_content second_answer.body

        fill_in 'Query', with: 'body'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_answer.body
        expect(page).to have_content second_answer.body

        fill_in 'Query', with: 'something'
        click_on 'Search'

        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_answer.body
        expect(page).not_to have_content second_answer.body
        expect(page).to have_content 'No entries found'
      end
    end

    context 'when there are any questions with coincident query' do
      given!(:question) { create :question, body: 'Question body' }

      scenario 'and does not find questions' do
        ThinkingSphinx::Test.run do
          expect(page).not_to have_content question.title
          expect(page).not_to have_content question.body

          fill_in 'Query', with: 'body'
          click_on 'Search'

          expect(page).not_to have_content question.title
          expect(page).not_to have_content question.body
        end
      end
    end
  end

  scenario 'User can not search answers without Answer checkbox selected' do
    ThinkingSphinx::Test.run do
      fill_in 'Query', with: 'body'
      click_on 'Search'

      expect(page).to have_content 'You should choose type of results'
      expect(page).not_to have_content first_answer.body
      expect(page).not_to have_content second_answer.body
    end
  end
end
