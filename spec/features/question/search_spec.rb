require 'sphinx_helper'

feature 'User can search the question', sphinx: true, js: true do
  given!(:first_question) { create :question, title: 'First title', body: 'One body' }
  given!(:second_question) { create :question, title: 'Second title', body: 'Two body' }

  before { visit search_path }

  context 'User select question search checkbox' do
    before { check 'question' }

    scenario 'and searches the question by title' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_question.title
        expect(page).not_to have_content second_question.title

        fill_in 'Query', with: 'first'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_question.title
        expect(page).not_to have_content second_question.title

        fill_in 'Query', with: 'second'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).not_to have_content first_question.title
        expect(page).to have_content second_question.title

        fill_in 'Query', with: 'title'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_question.title
        expect(page).to have_content second_question.title
      end
    end

    scenario 'and serarches the question by body' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_question.body
        expect(page).not_to have_content second_question.body

        fill_in 'Query', with: 'one'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_question.body
        expect(page).not_to have_content second_question.body

        fill_in 'Query', with: 'two'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).not_to have_content first_question.body
        expect(page).to have_content second_question.body

        fill_in 'Query', with: 'body'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_question.body
        expect(page).to have_content second_question.body

        fill_in 'Query', with: 'something'
        click_on 'Search'

        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_question.body
        expect(page).not_to have_content second_question.body
        expect(page).to have_content 'No entries found'
      end
    end

    context 'when there are any answer with coincident query' do
      given!(:answer) { create :answer, body: 'Answer body' }

      scenario 'and do not find answer' do
        ThinkingSphinx::Test.run do
          expect(page).not_to have_content answer.body

          fill_in 'Query', with: 'body'
          click_on 'Search'

          expect(page).not_to have_content answer.body
        end
      end
    end
  end

  scenario 'User can not search questions without question checkbox selected' do
    ThinkingSphinx::Test.run do
      fill_in 'Query', with: 'body'
      click_on 'Search'

      expect(page).to have_content 'You should choose type of results'
      expect(page).not_to have_content first_question.body
      expect(page).not_to have_content second_question.body
    end
  end
end
