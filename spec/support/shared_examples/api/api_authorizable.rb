RSpec.shared_examples "API authorizable" do
  let(:params_data) { defined?(params) ? params : {} }

  describe 'unauthorized' do
    it 'returns unauthorized status if no access_token' do
      do_request(method, api_path, params: params_data, headers: headers)
      expect(response).to be_unauthorized
    end

    it 'returns unauthorized status if access_token is invalid' do
      do_request(method, api_path, params: params_data.merge(access_token: '1234'), headers: headers)
      expect(response).to be_unauthorized
    end
  end

  describe 'authorized' do
    it 'returns successful status' do
      do_request(method, api_path, params: params_data.merge(access_token: access_token.token), headers: headers)
      expect(response).to be_successful
    end
  end
end
