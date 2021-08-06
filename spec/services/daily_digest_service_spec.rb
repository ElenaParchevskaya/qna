require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list :user, 2 }
  let(:before_yesterday_question) do
    create :question, created_at: 2.days.ago.end_of_day
  end

  let(:yesterday_questions) { create_list :question, 2, created_at: 1.day.ago.beginning_of_day }

  before do
    users
    before_yesterday_question
    yesterday_questions
  end

  it 'sends daily digest for all users with yesterday questions' do
    User.all.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user, yesterday_questions).and_call_original
    end
    subject.send_digest
  end
 end
