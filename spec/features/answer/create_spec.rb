require 'rails_helper'

feature 'User can create answer for question on the question`s show page' do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid parameters', js: true do
      fill_in 'Body', with: 'Some text'
      click_on 'Answer'

      expect(page).to have_content('Your answer successfully created.')
      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.answers' do
        expect(page).to have_content('Some text')
      end
    end

    scenario 'with invalid parameters', js: true do
      click_on 'Answer'
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'answers a question with attached file', js: true do
      fill_in 'Body', with: 'Some text'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'answers a question with attached two files', js: true do
      fill_in 'Body', with: 'Some text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Multiple sessions', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:other_question) { create :question }
    given(:another_user) { create :user }

    scenario "Answer appears on guests page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          within '#links' do
            click_on 'Add link'
            fill_in 'Name', with: 'Thinknetica'
            fill_in 'Url', with: 'https://thinknetica.com'
          end
          click_on 'Answer'
        end
      end

      Capybara.using_session('guest') do
        within ".answers" do
          expect(page).to have_content 'Some text'
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'
          expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
          expect(page).to have_no_link 'Best answer'
          expect(page).to have_content 'Comments'
        end
      end
    end

    scenario "Answer appears on another user page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          click_on 'Answer'
        end
      end

      Capybara.using_session('another_user') do
        within ".answers" do
          expect(page).to have_content 'Some text'
          expect(page).to have_no_link 'Best answer'
          expect(page).to have_content 'Comments'
          expect(page).to have_content 'New comment'
        end
      end
    end

    scenario "Answer don't appears on another question's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other_question') do
        visit question_path(other_question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          click_on 'Answer'
        end
      end

      Capybara.using_session('other_question') do
        expect(page).not_to have_content 'Some text'
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'can not create answer for question' do
      visit question_path(question)
      expect(page).to have_content('You need to be signed in to answer questions')
    end
  end
end
