require 'rails_helper'

describe 'Questions API', type: :request do
  subject { send method, api_path, params: { access_token: access_token.token }, headers: headers }

  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:access_token) { create :access_token }
  let(:user) { User.find(access_token.resource_owner_id) }

  let(:resource_class) { Question }
  let(:resource) { question }
  let(:resource_json) { json }
  let(:attributes) { %w[id title body created_at updated_at] }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    let!(:questions) { create_list :question, 2 }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:question) { questions.first }
      let(:questions_json) { json }
      let(:resource_json) { questions_json.first }

      it 'returns list of questions' do
        subject
        expect(questions_json.size).to eq questions.size
      end

      it_behaves_like 'API serializable'
      it_behaves_like 'API ownerable'
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    let(:question) { create :question }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API serializable'
    it_behaves_like 'API ownerable'
    it_behaves_like 'API commentable'
    it_behaves_like 'API linkable'
    it_behaves_like 'API attachable'
  end

  describe 'POST /api/v1/questions' do
    subject { post api_path, params: params.merge(access_token: access_token.token), headers: headers }

    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }

    let(:question) { Question.order(:created_at).last }
    let(:params) { { question: attributes_for(:question) } }

    it_behaves_like 'API authorizable'

    it_behaves_like 'API create resource' do
      let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
      let(:invalid_attribute) { 'Body' }
    end

    it_behaves_like 'API create linkable'
    it_behaves_like 'API serializable'
    it_behaves_like 'API ownerable'
  end

  describe 'PATCH /api/v1/questions/:id' do
    subject { patch api_path, params: params.merge(access_token: access_token.token), headers: headers }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    let(:question) { create :question, author: user }

    let(:update_attributes) { { title: 'Edited title', body: 'Edited body' } }
    let(:params) { { question: update_attributes } }

    it_behaves_like 'API authorizable'

    it_behaves_like 'API update resource' do
      let(:invalid_params) { { question: { title: ' ', body: 'Edited body' } } }
      let(:invalid_attribute) { 'Title' }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    let!(:question) { create :question, author: user }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API destroy resource'
  end
end
