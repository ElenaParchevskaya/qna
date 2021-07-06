require 'rails_helper'

feature 'Authenticated user can sign out' do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
