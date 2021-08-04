RSpec.shared_examples 'API create linkable' do
  context 'with links' do
    let(:resource_name) { resource_class.to_s.underscore.to_sym }
    let(:params) { { resource_name => attributes_for(resource_name).merge(links_attributes) } }
    let(:links_json) { resource_json['links'] }

    context 'where links is valid' do
      let(:links_attributes) do
        { links_attributes: { 0 => { name: 'Thinknetica', url: 'https://thinknetica.com' },
                               1 => { name: 'Wiki', url: 'https://wikipedia.org' } } }
      end

      before { subject }

      it 'adds links' do
        expect(resource.links.pluck(:name).sort).to eq %w[Thinknetica Wiki]
        expect(resource.links.pluck(:url).sort).to eq ['https://thinknetica.com', 'https://wikipedia.org']
      end

      it 'returns list of links' do
        expect(links_json.size).to eq 2
      end

      it 'returns attributes of each link' do
        expect(links_json.map { |l| l['name'] }.sort).to eq %w[Thinknetica Wiki]
        expect(links_json.map { |l| l['url'] }.sort).to eq ['https://thinknetica.com', 'https://wikipedia.org']
      end
    end

    context 'where links is not valid' do
      let(:links_attributes) do
        { links_attributes: { 0 => { url: 'https://thinknetica.com' } } }
      end

      it 'does not create new resource' do
        expect { subject }.not_to change(resource_class, :count)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors in json' do
        subject
        expect(json['errors']).to be_present
        expect(json['errors'].first).to eq "Links name can't be blank"
      end
    end
  end
end
