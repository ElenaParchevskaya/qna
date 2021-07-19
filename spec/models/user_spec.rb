require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:awards) }
  end

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
end
