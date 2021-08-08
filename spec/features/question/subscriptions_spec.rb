require 'rails_helper'

feature 'User can subscribe the question' do
  given(:question) { create :question }

  describe 'Authenticated user' do
    given(:user) { create :user }

    background { sign_in(user) }

    describe 'as not an author of question' do
      scenario 'views the invitation to subscribe to the question' do
        visit question_path(question)

        expect(page).not_to have_link('Unsubscribe')
        expect(page).not_to have_content 'You are subscribed to this question'
        expect(page).to have_link('Subscribe')
      end

      scenario 'subscribes the question', js: true do
        visit question_path(question)
        expect(page).not_to have_content 'You are subscribed to this question'
        click_on 'Subscribe'

        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
        expect(page).to have_content 'You are subscribed to this question'
      end

      context 'when user has got a subscription of the question' do
        background { question.subscriptions.create!(user: user) }

        scenario 'views the message that he is already subscribed' do
          visit question_path(question)

          expect(page).not_to have_link('Subscribe')
          expect(page).to have_link('Unsubscribe')
          expect(page).to have_content 'You are subscribed to this question'
        end

        scenario 'unsubscribes to the question', js: true do
          visit question_path(question)
          expect(page).to have_content 'You are subscribed to this question'
          click_on 'Unsubscribe'

          expect(page).not_to have_link('Unsubscribe')
          expect(page).not_to have_content 'You are subscribed to this question'
        end

        scenario 'can again subscribe to the question after he unsubscribed', js: true do
          visit question_path(question)
          click_on 'Unsubscribe'
          click_on 'Subscribe'

          expect(page).not_to have_link('Subscribe')
          expect(page).to have_link('Unsubscribe')
        end
      end
    end

    describe 'as an author of question' do
      given(:question) { create :question, author: user }

      scenario 'views message that he is already subscribed as author' do
        visit question_path(question)

        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
        expect(page).to have_content 'You are subscribed to this question'
      end

      scenario 'unsubscribes to the question', js: true do
        visit question_path(question)
        expect(page).to have_content 'You are subscribed to this question'
        click_on 'Unsubscribe'

        expect(page).not_to have_link('Unsubscribe')
        expect(page).not_to have_content 'You are subscribed to this question'
      end

      scenario 'can again subscribe to the question after he unsubscribed', js: true do
        visit question_path(question)
        click_on 'Unsubscribe'
        click_on 'Subscribe'

        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribe or unsubscribe the question' do
      visit question_path(question)

      expect(page).not_to have_link('Subscribe')
      expect(page).not_to have_link('Unsubscribe')
      expect(page).not_to have_content 'You are subscribed to this question'
    end
  end
end
