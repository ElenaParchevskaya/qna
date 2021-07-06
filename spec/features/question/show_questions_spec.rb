require 'rails_helper'

feature 'Someone can get list of questions' do
  background { create_list(:question, 4) }

  scenario 'get list of questions' do
    visit questions_path
    expect(page).to have_content 'Questions'
    expect(page.all('li', text: 'MyTitle').size).to eq Question.count
  end
end
