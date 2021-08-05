RSpec.shared_examples 'update resource' do
  subject { patch :update, params: { id: resource, resource_name => update_attributes }, format: :js }

  let(:resource_name) { resource.class.to_s.underscore.to_sym }

  describe 'by authenticated user' do
    before { login(user) }

    context 'when his resource with valid params' do
      it 'changes resource' do
        subject
        resource.reload
        update_attributes.each do |attr_name, value|
          expect(resource.send(attr_name)).to eq value
        end
      end

      it { is_expected.to render_template(:update) }
    end

    context 'with attached files' do
      it 'attaches files to question' do
        patch :update,
              params: { id: resource, resource_name => { files: [fixture_file_upload('spec/spec_helper.rb')] } }, format: :js
        expect(resource.reload.files).to be_attached
      end
    end

    context 'when his resource with invalid params' do
      subject { patch :update, params: { id: resource, resource_name => invalid_attributes }, format: :js }

      it 'does not change question' do
        update_attributes.each_key do |attr_name|
          expect { subject }.not_to change(resource, attr_name)
        end
      end

      it { is_expected.to render_template(:update) }
    end

    context "when another user's resource" do
      subject { patch :update, params: { id: another_resource, resource_name => update_attributes, format: :js } }

      let!(:another_resource) { create resource_name }

      before { subject }

      it 'does not change resource' do
        update_attributes.each_key do |attr_name|
          expect { subject }.not_to change(another_resource, attr_name)
        end
      end

      it 'returns forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'by unauthenticated user' do
    it 'does not change resources`s attributes' do
      update_attributes.each_key do |attr_name|
        expect { subject }.not_to change(resource, attr_name)
      end
    end
  end
end
