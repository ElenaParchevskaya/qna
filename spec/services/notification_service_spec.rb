require 'rails_helper'

RSpec.describe NotificationService do
  describe '#new_answer' do
    let!(:user) { create :user }
    let(:question) { create :question }
    let(:question_owner) { question.author }

    let(:answer) { create :answer, question: question }

    context 'when there are no other subscribers except owner' do
      it 'sends new answer notification mail to owner of question only' do
        expect(NotificationMailer).to receive(:new_answer).with(question_owner, answer).and_call_original
        expect(NotificationMailer).not_to receive(:new_answer).with(user, answer)
        subject.new_answer(answer)
      end
    end

    context 'when there are other subscribers' do
      let(:subscribed_users) do
        create_list(:user, 2).tap do |users|
          users.each { |user| create :subscription, question: question, user: user }
        end
      end

      it 'sends new answer notification mail to all subsribed users of question' do
        (subscribed_users + [question_owner]).each do |user|
          expect(NotificationMailer).to receive(:new_answer).with(user, answer).and_call_original
        end
        subject.new_answer(answer)
      end
    end
  end
end
