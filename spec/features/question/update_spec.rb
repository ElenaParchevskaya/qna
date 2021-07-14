require 'rails_helper'

feature 'User can update question' do
  describe 'authenticated user' do
    describe 'is author of question', js: true do
      given(:question) { create(:question) }
      given(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should update' do
        click_on 'Edit question'

        within "#question-#{question.id}" do
          fill_in 'Body', with: 'Edited Question'
          click_on 'Edit'
        end
        expect(page).not_to have_link 'Edit', exact: true
        expect(page).to have_content 'Edited Question'
      end

      scenario 'updates a question with errors' do
        click_on 'Edit question'

        within "#question-#{question.id}" do
          fill_in 'Body', with: nil
          click_on 'Edit'
        end

        expect(page).to have_content "Body can't be blank"
      end

      scenario 'adds attached files' do
        click_on 'Edit question'

        within "#question-#{question.id}" do
          expect(page).to have_no_link 'rails_helper.rb'
          expect(page).to have_no_link 'spec_helper.rb'

          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
           click_on 'Edit'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      context 'when question has file' do
        background do
          question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
          visit question_path(question)
          click_on 'Edit question'
        end

        scenario 'adding attached files to question with files' do
          within "#question-#{question.id}" do
            expect(page).to have_content 'rails_helper.rb'
            expect(page).to have_no_content 'spec_helper.rb'

            attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Edit'

            expect(page).to have_content 'rails_helper.rb'
            expect(page).to have_content 'spec_helper.rb'
          end
        end
      end
    end

    describe 'is not author of question' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'should not update', js: true do
        within "#question-#{question.id}" do
          expect(page).not_to have_link 'Edit question'
        end
      end
    end
  end
end
