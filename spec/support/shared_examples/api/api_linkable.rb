RSpec.shared_examples 'API linkable' do
  context 'when it has any links' do
    let!(:links) { create_list :link, 2, linkable: resource }
    let(:links_json) { resource_json['links'] }

    before { subject }

    it 'returns list of links' do
      expect(links_json.size).to eq links.size
    end

    it 'returns attributes of each link' do
      links.each do |link|
        link_json = links_json.find { |l| l['id'] == link.id }
        %w[id name url gist? created_at updated_at].each do |attr|
          expect(link_json[attr]).to eq link.send(attr).as_json
        end
      end
    end
  end
end
