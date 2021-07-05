require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
  end

  describe '#author?' do
    let(:user) { create(:user) }

    context 'when return true' do
      it 'user is author of question' do
        question = create(:question, author: user)
        expect(user.author?(question)).to be(true)
      end

      it 'user is author of answer' do
        answer = create(:answer, author: user)
        expect(user.author?(answer)).to be(true)
      end
    end

    context 'when return false' do
      it 'user is not author of resource' do
        answer = create(:answer)
        expect(user.author?(answer)).to be(false)
      end
    end
  end
end
