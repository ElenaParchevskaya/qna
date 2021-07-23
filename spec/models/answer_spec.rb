require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:links).dependent(:destroy) }
    it { should accept_nested_attributes_for :links }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'callbacks' do
    describe '#clear_best_answer' do
      let(:question) { answer.question }
      let(:answer) { create(:answer) }

      it 'clear best answer' do
        answer.mark_as_best_answer
        answer.destroy
        expect(question.best_answer).to be nil
      end
    end
  end

  describe '#best_answer?' do
    context 'when answer is the best' do
      let!(:answer) { create(:answer) }
      let!(:question) { answer.question }

      it 'marks as best' do
        answer.mark_as_best_answer
        expect(answer.best_answer?).to be true
      end
    end

    context 'when answer isn`t best' do
      let(:answer) { create(:answer) }
      let(:question) { answer.question }

      it 'does not mark as best' do
        expect(answer.best_answer?).to be false
      end
    end
  end

  context 'when question has an award' do
    let(:question) { create :question }
    let(:answers) { create_list :answer, 2, question: question }
    let!(:award) { create :award, question: question }

    before { answers.second.mark_as_best_answer }

    it 'gives award to the user of the best answer' do
      expect(answers.second.author.awards).to eq [award]
    end

    context 'when another user has award of this question' do
      it 'takes away award from another user' do
        expect(answers.second.author.awards).to eq [award]
        answers.first.mark_as_best_answer
        expect(answers.second.author.awards.reload).to eq []
      end
    end
  end

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like "linkable"
  it_behaves_like "votable"
  it_behaves_like "commentable"
end
