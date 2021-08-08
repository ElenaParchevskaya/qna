require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:awards) }
    it { should have_many(:comments) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  it {
    expect(subject).to have_many(:access_grants).class_name('Doorkeeper::AccessGrant')
                                                .with_foreign_key(:resource_owner_id).dependent(:destroy)
   }

   it {
     expect(subject).to have_many(:access_tokens).class_name('Doorkeeper::AccessToken')
                                                 .with_foreign_key(:resource_owner_id).dependent(:destroy)
   }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    context 'when return true' do
      it 'user is author of question' do
        expect(user).to be_author_of(question)
      end

      it 'user is author of answer' do
        answer = create(:answer, author: user)
        expect(user).to be_author_of(answer)
      end
    end

    context 'when return false' do
      it 'user is not author of resource' do
        answer = create(:answer)
        expect(user).not_to be_author_of(answer)
      end
    end
  end

  describe '#subscribed?' do
    let(:user) { create :user }

    let(:question) { create :question }

    it 'true if user is subscribed to question' do
      question.subscriptions.create!(user: user)
      expect(user).to be_subscribed(question)
    end

    it 'false if user is not subscribed to question' do
      expect(user).not_to be_subscribed(question)
    end
  end
end
