require 'rails_helper'

RSpec.describe SearchService do
  let(:query) { 'something' }
  let(:other_klass) { Question }
  let(:other_klass) { Question }
  let(:questions) { build_list :question, 2 }
  let(:answers) { build_list :answer, 2 }
  let(:comments) { build_list :comment, 2 }
  let(:users) { build_list :user, 2 }

  before do
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Answer]).and_return(answers)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Question]).and_return(questions)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Comment]).and_return(comments)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [User]).and_return(users)
    allow(ThinkingSphinx).to receive(:search).with(query,
                                                   classes: [Question, Answer, Comment,
                                                             User]).and_return(questions + answers + comments + users)
  end

  context 'questions only search' do
    it_behaves_like 'search by class' do
      let(:klass) { Question }
      let(:other_klass) { Answer }
    end
  end

  context 'answers only search' do
    it_behaves_like('search by class') { let(:klass) { Answer } }
  end

  context 'comments only search' do
    it_behaves_like('search by class') { let(:klass) { Comment } }
  end

  context 'users only search' do
    it_behaves_like('search by class') { let(:klass) { User } }
  end

  context 'global search' do
    context 'when resources includes all searchable classes' do
      subject { described_class.new(query, %w[question answer comment user]) }

      it 'calls search method of ThinkingSphinx with query and all searchable classes' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [Question, Answer, Comment, User])
        subject.call
      end

      it 'returns found results' do
        expect(subject.call).to eq questions + answers + comments + users
      end
    end
  end
end
