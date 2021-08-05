RSpec.shared_examples 'API update resource' do
  describe 'API resource owner is an owner of edited resource' do
    context 'with valid params' do
      it 'changes resource' do
        subject
        resource.reload
        update_attributes.each do |attr_name, value|
          expect(resource.send(attr_name)).to eq value
        end
      end

      it_behaves_like 'API serializable'
    end

    context 'with invalid params' do
      let(:params) { invalid_params }

      it 'does not change resource' do
        update_attributes.each_key do |attr_name|
          expect { subject }.not_to change(resource, attr_name)
        end
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

  describe 'resource owner is not an owner of question' do
    before { resource.update_column :user_id, create(:user).id }

    it 'does not change resource' do
      update_attributes.each_key do |attr_name|
        expect { subject }.not_to change(resource, attr_name)
      end
    end

    it 'returns forbidden status' do
      subject
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns empty response' do
      subject
      expect(response.body).to be_empty
    end
  end
end
