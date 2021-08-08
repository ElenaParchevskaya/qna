require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double 'DailyDigestService' }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_digest' do
    expect(service).to receive(:send_digest)
    described_class.perform_now
  end
end
