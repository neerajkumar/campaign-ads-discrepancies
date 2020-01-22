# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::DiscrepanciesServices::DiscrepanciesDetector do
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
      allow(CampaignAdsDiscrepancies::CampaignsServices::GetCampaigns).to receive(:call).and_return([campaign])
      allow(Net::HTTP).to receive(:get).and_return(response)
    end

    subject { described_class.call }

    context 'when no discrepancy found' do
      let(:campaign) { build(:campaign, ad_description: 'Description for campaign 11') }

      it 'returns no result' do
        expect(subject).to be_empty
        expect(subject).to be_kind_of(Array)
      end
    end

    context 'when discrepancies found' do
      let(:campaign) { build(:campaign, status: 'deleted') }

      it 'returns discrepancies with status and description fields both' do
        remote_ad_response = JSON.parse(response)

        expect(subject).not_to be_empty
        expect(subject.size).to eq(1)
        expect(subject[0][:discrepancies][0]['status']).not_to be_nil
        expect(subject[0][:discrepancies][0]['status']).to include(remote: remote_ad_response['ads'][0]['status'], local: campaign.status)
        expect(subject[0][:discrepancies][0]['description']).not_to be_nil
        expect(subject[0][:discrepancies][0]['description']).to include(remote: remote_ad_response['ads'][0]['description'], local: campaign.ad_description)
      end
    end
  end
end
