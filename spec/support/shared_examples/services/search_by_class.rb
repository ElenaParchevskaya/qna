RSpec.shared_examples 'search by class' do
  let(:klass_resource) { klass.to_s.underscore }
  let(:other_klass_resource) { other_klass.to_s.underscore }
  let(:results) { send(klass.table_name) }

  context 'when resources includes search Class resource' do
    subject { SearchService.new(query, klass_resource) }

    it 'calls search method of ThinkingSphinx with query and classes with search Class' do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [klass])
      subject.call
    end

    it 'returns found results' do
      allow(ThinkingSphinx).to receive(:search).with(query, classes: [klass]).and_return(results)
      expect(subject.call).to eq results
    end
  end

  context 'when resources does not include Class resource' do
    subject { SearchService.new(query, other_klass_resource) }

    it 'does not call search method of ThinkingSphinx with classes with search Class' do
      expect(ThinkingSphinx).not_to receive(:search).with(query, classes: [klass])
      expect(ThinkingSphinx).not_to receive(:search).with(query, classes: [klass, other_klass])
      expect(ThinkingSphinx).not_to receive(:search).with(query, classes: [other_klass, klass])
       subject.call
    end

    it 'does not return any records of search Class' do
      expect(subject.call.map(&:class)).not_to be_any(klass)
    end
  end
end
