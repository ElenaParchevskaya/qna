RSpec.shared_examples 'API attachable' do
  context 'when it has any attached files' do
    let(:filenames) { ['spec_helper.rb', 'rails_helper.rb'] }
    let(:files_json) { resource_json['files'] }

    before do
      resource.update(files: filenames.map { |filename| fixture_file_upload("spec/#{filename}") })
      subject
    end

    it 'returns list of of attached files' do
      expect(files_json.size).to eq filenames.size
    end

    it 'returns attributes of each file' do
      filenames.each do |filename|
        file_json = files_json.find { |f| f['filename'] == filename }
        expect(file_json['url']).to include filename
      end
    end
  end
end
