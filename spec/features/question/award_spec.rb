require 'rails_helper'

feature 'User can add award when create question' do
  given(:user) { create :user }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User add award when asks a question' do
    within '.award' do
      fill_in 'Name', with: 'Award name'
      attach_file 'Image', Rails.root.join('spec/fixtures/appwatch.jpeg')
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'For the best answer you will receive'
    expect(page).to have_content 'Award name'
    expect(page).to have_css("img[src*='appwatch.jpeg']")
  end

  scenario 'User add award with invalid image when asks a question' do
    within '.award' do
      fill_in 'Name', with: 'Award name'
      attach_file 'Image', Rails.root.join('spec/spec_helper.rb')
    end

    click_on 'Ask'

    expect(page).not_to have_content 'Your question successfully created.'
    expect(page).not_to have_content 'For the best answer you will receive'
    expect(page).not_to have_content 'Award name'
    expect(page).to have_content "Award image has an invalid content type"
  end

  scenario 'User add award without image when asks a question' do
    within '.award' do
      fill_in 'Name', with: 'Award without image'
    end

    click_on 'Ask'

    expect(page).not_to have_content 'Your question successfully created.'
    expect(page).not_to have_content 'For the best answer you will receive'
    expect(page).not_to have_content 'Award without image'
    expect(page).to have_content "Award image can't be blank"
  end

  scenario 'User asks a question with empty award name' do
    within '.award' do
      fill_in 'Name', with: ' '
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).not_to have_content 'For the best answer you will receive'
  end
end
