require 'rails_helper'

feature 'Someone can get list of answers' do
  describe 'when question has answers' do
    given(:question) { create(:question, :with_answers) }
    given(:expected_answers) { question.answers.pluck(:body) }

    scenario 'show list of answers' do
      visit question_path(question)

      question.answers.pluck(:body).each do |body|
        expect(page).to have_content body
      end
    end
  end

  describe 'when question has not answers' do
    given(:question) { create(:question) }

    scenario 'show message "No answers"' do
      visit question_path(question)

      expect(page).to have_content('No answers')
    end
  end
end
