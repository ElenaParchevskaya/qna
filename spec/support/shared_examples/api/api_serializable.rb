RSpec.shared_examples 'API serializable' do
  it 'returns all public attributes in json' do
    subject
    resource.reload
    attributes.each do |attr|
      expect(resource_json[attr]).to eq resource.send(attr).as_json
    end
  end
end
