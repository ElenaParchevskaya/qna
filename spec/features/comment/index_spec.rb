require 'rails_helper'

feature 'User can view comments for question or answer' do
  given(:question) { create :question }
  given(:answer) { create :answer, question: question }

  describe 'When there are some comments for question' do
    given!(:question_comments) { create_list :comment, 2, commentable: question }

    scenario 'user views comments list in question block' do
      visit question_path(question)

      within "#question-#{question.id}-comments" do
        expect(page).to have_content question_comments.first.body
        expect(page).to have_content question_comments.second.body
      end
    end
  end

  describe 'When there are some comments for answer' do
    given!(:answer_comments) { create_list :comment, 2, commentable: answer }

    scenario 'user views comments list in this answer block' do
      visit question_path(question)

      within "#answer-#{answer.id}-comments" do
        expect(page).to have_content answer_comments.first.body
        expect(page).to have_content answer_comments.second.body
      end
    end
  end
end
