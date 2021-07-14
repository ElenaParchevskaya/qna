require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:my_gist_link) { 'https://gist.github.com/ElenaParchevskaya/839479a0bd976d42de81ec3fa502fb6d' }

  background { sign_in(user) }

  describe 'User creates answer', js: true do
    background { visit question_path(question) }

    scenario 'with one link' do
      fill_in 'Body', with: 'Some text'

      within '.new_answer' do
        within '#links' do
          click_on 'Add link'
          fill_in 'Name', with: 'Thinknetica'
          fill_in 'Url', with: 'https://thinknetica.com'
        end
        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
      end
    end

    scenario 'with several links' do
      fill_in 'Body', with: 'Some text'

      within '.new_answer' do
        within '#links' do
          click_on 'Add link'
          fill_in 'Name', with: 'Thinknetica'
          fill_in 'Url', with: 'https://thinknetica.com'

          click_on 'Add link'
          within all('.nested-fields').last do
            fill_in 'Name', with: 'Wiki'
            fill_in 'Url', with: 'https://www.wikipedia.org'
          end
        end
        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
        expect(page).to have_link 'Wiki', href: 'https://www.wikipedia.org'
      end
    end

    scenario 'with invalid url link' do
      fill_in 'Body', with: 'Some text'

      within '.new_answer' do
        within '#links' do
          click_on 'Add link'
          fill_in 'Name', with: 'Thinknetica'
          fill_in 'Url', with: 'htps://thinknetica.com'
        end
        click_on 'Answer'
      end

      expect(page).to have_no_link 'Thinknetica', href: 'https://thinknetica.com'
      expect(page).to have_content "Links url is not a valid URL"
    end

    scenario 'with gist link' do
      fill_in 'Body', with: 'Some text'

      within '#links' do
        click_on 'Add link'
        fill_in 'Name', with: 'My gist'
        fill_in 'Url', with: my_gist_link
      end
      click_on 'Answer'

      expect(page).to have_no_link 'My gist', href: my_gist_link
    end

    scenario 'with wrong gist link' do
      wrong_gist_link = my_gist_link.tr('9', '8')

      fill_in 'Body', with: 'Some text'

      within '#links' do
        click_on 'Add link'
        fill_in 'Name', with: 'My gist'
        fill_in 'Url', with: wrong_gist_link
      end
      click_on 'Answer'

      expect(page).to have_no_link 'My gist', href: wrong_gist_link
      expect(page).to have_no_content "Have a nice day!"
    end
  end

  describe 'User edits his answer', js: true do
    given(:answer) { create :answer, author: user }

    context 'when answer has no any links' do
      scenario 'and add link to answer' do
        visit question_path(answer.question)
        within "#answer-#{answer.id}" do
          click_on 'Edit answer'

          expect(page).to have_no_link 'Thinknetica', href: 'https://thinknetica.com'

          within '#links' do
            click_on 'Add link'
            fill_in 'Name', with: 'Thinknetica'
            fill_in 'Url', with: 'https://thinknetica.com'
          end
          click_on 'Edit'

          expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
        end
      end
    end

    context 'when answer has links' do
      given!(:link) { create :link, linkable: answer }

      scenario 'and add link to answer' do
        visit question_path(answer.question)
        within "#answer-#{answer.id}" do
          click_on 'Edit answer'

          expect(page).to have_link link.name, href: link.url
          expect(page).to have_no_link 'Thinknetica', href: 'https://thinknetica.com'

          within '#links' do
            click_on 'Add link'
            fill_in 'Name', with: 'Thinknetica'
            fill_in 'Url', with: 'https://thinknetica.com'
          end
          click_on 'Edit'

          expect(page).to have_link link.name, href: link.url
          expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
        end
      end
    end
  end
end
