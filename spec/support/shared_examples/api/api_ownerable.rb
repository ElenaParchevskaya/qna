RSpec.shared_examples 'API ownerable' do
  it 'returns owner as an user' do
    subject
    expect(resource_json['author']['id']).to eq resource.author.id
    expect(resource_json['author']['email']).to eq resource.author.email
  end
end
