require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { create :user }

  describe "new_answer" do
    let(:answer) { create :answer }
    let(:mail) { described_class.new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for question \"#{answer.question.title}\"")
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
