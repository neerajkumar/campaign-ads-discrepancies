# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::RemoteAd do
  describe '#initialize' do
    let(:params) do
      {
        reference: '1',
        status: 'enabled',
        description: 'Remote Ad Description'
      }
    end

    subject { described_class.new(params) }

    it 'returns an instance of CampaignAdsDiscrepancies::RemoteAd class' do
      expect(subject).to be_an_instance_of(described_class)
    end

    it 'returns different attributes of CampaignAdsDiscrepancies::RemoteAd object' do
      expect(subject.reference).to eq(params[:reference])
      expect(subject.status).to eq(params[:status])
      expect(subject.description).to eq(params[:description])
    end
  end
end
