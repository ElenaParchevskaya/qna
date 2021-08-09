require 'sphinx_helper'

feature 'User can search any record', sphinx: true, js: true do
  given!(:user) { create :user, email: 'someuser@email.com' }
  given!(:question) { create :question, title: 'Question title', body: 'Question body', author: user }
  given!(:answer) { create :answer, body: 'Answer body', author: user }
  given!(:comment) { create :comment, body: 'Comment body', user: user }

  before { visit search_path }

  context 'User selects question and answer search checkboxes' do
    before do
      check 'question'
      check 'answer'
    end

    scenario 'and searches the questions and answers together' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body

        fill_in 'Query', with: 'body'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
      end
    end
  end

  context 'User selects question, answer and comment search checkboxes' do
    before do
      check 'question'
      check 'answer'
      check 'comment'
    end

    scenario 'and searches the questions, answers and comments together' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body
        expect(page).not_to have_content comment.body

        fill_in 'Query', with: 'body'
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
      end
    end
  end

  context 'User selects question, answer, comment and user search checkboxes' do
    before do
      check 'question'
      check 'answer'
      check 'comment'
      check 'user'
    end

    scenario 'and searches the questions, answers, comments and users together' do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content 'Results'
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body
        expect(page).not_to have_content comment.body
        expect(page).not_to have_content user.email

        fill_in 'Query', with: user.email
        click_on 'Search'

        expect(page).to have_content 'Results'
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content user.email
      end
    end
  end
end
