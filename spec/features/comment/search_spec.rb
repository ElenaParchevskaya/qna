require 'sphinx_helper'

feature 'User can search the comment', sphinx: true, js: true do
  given!(:first_comment) { create :comment, body: 'One body' }
  given!(:second_comment) { create :comment, body: 'Two body' }

  before { visit search_path }

  context 'User select comment search checkbox' do
    before { check 'Comment' }

    scenario 'and searches the comment by body' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_comment.body
        expect(page).not_to have_content second_comment.body

        fill_in 'Query', with: 'one'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_comment.body
        expect(page).not_to have_content second_comment.body

        fill_in 'Query', with: 'two'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).not_to have_content first_comment.body
        expect(page).to have_content second_comment.body

        fill_in 'Query', with: 'body'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content first_comment.body
        expect(page).to have_content second_comment.body

        fill_in 'Query', with: 'something'
        click_on 'Search'

        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content first_comment.body
        expect(page).not_to have_content second_comment.body
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

  scenario 'User can not search comments without comment checkbox selected' do
    ThinkingSphinx::Test.run do
      fill_in 'Query', with: 'body'
      click_on 'Search'

      expect(page).to have_content 'You should choose type of results'
      expect(page).not_to have_content first_comment.body
      expect(page).not_to have_content second_comment.body
    end
  end
end
