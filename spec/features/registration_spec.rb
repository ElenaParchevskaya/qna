require 'rails_helper'

feature 'Unauthenticated user can tries to register' do
  background { visit new_user_registration_path }

  describe 'User has never been registered before' do
    scenario 'with valid parameters' do
      fill_in 'Email', with: attributes_for(:user)[:email]
      fill_in 'Password', with: attributes_for(:user)[:password]
      fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'with invalid parameters' do
      fill_in 'Email', with: attributes_for(:user)[:email]
      fill_in 'Password', with: ''
      click_button 'Sign up'

      expect(page).to have_content 'prohibited this user from being saved'
    end
  end

  describe 'User was registered before' do
    given(:user) { create(:user) }

    scenario 'with the same parameters' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
