# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::RemoteAdsServices::GetRemoteAds do
  describe '#initialize' do
    subject { described_class.new }

    it 'returns an instance of CampaignAdsDiscrepancies::CampaignsServices::GetRemoteAds class' do
      expect(subject).to be_an_instance_of(described_class)
    end

    it 'returns remote_url attribute of CampaignAdsDiscrepancies::CampaignsServices::GetRemoteAds object' do
      expect(subject.remote_url).to eq(URI(described_class::REMOTE_ADS_URL))
    end
  end

  describe '#call' do
    let(:response) do
      '{
        "ads": [
          {
            "reference": "1",
            "status": "enabled",
            "description": "Description for campaign 11"
          }
        ]
      }'
    end
    before do
      allow(Net::HTTP).to receive(:get).and_return(response)
    end

    subject { described_class.call }

    it 'returns collection of remote ad objects' do
      expect(subject).not_to be_empty
      expect(subject).to be_kind_of(Array)
      expect(subject.size).to eq(1)
      expect(subject[0]).to be_an_instance_of(CampaignAdsDiscrepancies::RemoteAd)
    end
  end
end
