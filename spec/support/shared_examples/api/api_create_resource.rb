RSpec.shared_examples 'API create resource' do
  describe 'authorized' do
    let(:user) { User.find(access_token.resource_owner_id) }

    context 'with valid params' do
      it 'creates new resource' do
        expect { subject }.to change(resource_class, :count).by(1)
      end

      it 'sets user attribute to resource owner' do
        subject
        expect(resource.author).to eq user
      end
    end

    context 'with invalid params' do
      let(:params) { invalid_params }

      it 'does not create new question' do
        expect { subject }.not_to change(resource_class, :count)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors in json' do
        subject
        expect(json['errors']).to be_present
        expect(json['errors'].first).to eq "#{invalid_attribute} can't be blank"
      end
    end
  end
end
