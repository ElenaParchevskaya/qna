require 'rails_helper'

feature 'User can add links to question', %q{
  In order to private additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create :user }
  given(:my_gist_link) { 'https://gist.github.com/ElenaParchevskaya/839479a0bd976d42de81ec3fa502fb6d' }

  background { sign_in(user) }

  describe 'User creates question', js: true do
    background { visit new_question_path }

    scenario 'with one link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '#links' do
        click_on 'Add link'
        fill_in 'Name', with: 'Thinknetica'
        fill_in 'Url', with: 'https://thinknetica.com'
      end
      click_on 'Ask'

      expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
    end

    scenario 'with several links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

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
      click_on 'Ask'

      expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
      expect(page).to have_link 'Wiki', href: 'https://www.wikipedia.org'
    end

    scenario 'with invalid url link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '#links' do
        click_on 'Add link'
        fill_in 'Name', with: 'Thinknetica'
        fill_in 'Url', with: 'hs://ggle.com'
      end
      click_on 'Ask'

      expect(page).to have_no_link 'Thinknetica', href: 'https://thinknetica.com'
      expect(page).to have_content "Links url is not a valid URL"
    end

    scenario 'with gist link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '#links' do
        click_on 'Add link'
        fill_in 'Name', with: 'My gist'
        fill_in 'Url', with: my_gist_link
       end
       click_on 'Ask'

       expect(page).to have_no_link 'My gist', href: my_gist_link
       expect(page).to have_content "Have a nice day!"
     end

     scenario 'with wrong gist link' do
       wrong_gist_link = my_gist_link.tr('9', '8')

       fill_in 'Title', with: 'Test question'
       fill_in 'Body', with: 'text text text'

       within '#links' do
         click_on 'Add link'
         fill_in 'Name', with: 'My gist'
         fill_in 'Url', with: wrong_gist_link
       end
       click_on 'Ask'

       expect(page).to have_no_link 'My gist', href: wrong_gist_link
       expect(page).to have_no_content "Have a nice day!"
     end
   end

   describe 'User edits his question', js: true do
     given(:question) { create :question, author: user }

     context 'when question has no any links' do
       scenario 'when add link to question' do
         visit question_path(question)
         click_on 'Edit question'

         within '.question' do
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

     context 'when question has links' do
       given!(:link) { create :link, linkable: question }

       scenario 'when add link to question' do
         visit question_path(question)
         click_on 'Edit question'

         within '.question' do
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
