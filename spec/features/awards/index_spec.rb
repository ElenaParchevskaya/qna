require 'rails_helper'

feature 'User can view his awards list' do
  given(:user) { create :user }

  describe 'Authenticated user' do
    before { sign_in(user) }

    describe 'there are awards' do
      given!(:user_awards) { create_list :award, 2, user: user }

      scenario 'view list of his awards only' do
        visit questions_path
        click_on 'My awards'

        user_awards.each do |award|
          expect(page).to have_content award.question.title
          expect(page).to have_content award.name
          expect(page).to have_css("img[src*='#{award.image.filename}']")
         end
      end
    end

    describe 'no awards' do
      given!(:awards) { create_list :award, 2 }

      scenario 'can view text that he has no awards' do
        visit questions_path
        click_on 'My awards'

        awards.each do |award|
          expect(page).not_to have_content award.question.title
          expect(page).not_to have_content award.name
          expect(page).not_to have_css("img[src*='#{award.image.filename}']")
        end

        expect(page).to have_content "You haven't any awards yet"
      end
    end
  end

  scenario 'Unauthenticated User doesnt view My awards link' do
    visit questions_path

    expect(page).to have_no_link 'My awards'
  end
end
