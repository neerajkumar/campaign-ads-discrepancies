# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::Campaign do
  describe '#initialize' do
    let(:params) do
      {
        id: 1,
        job_id: 100,
        status: 'active',
        external_reference: '1',
        ad_description: 'Ad Description'
      }
    end

    subject { described_class.new(params) }

    it 'returns an instance of CampaignAdsDiscrepancies::Campaign class' do
      expect(subject).to be_an_instance_of(described_class)
    end

    it 'returns the attributes for CampaignAdsDiscrepancies::Campaign object' do
      expect(subject.id).to eq(params[:id])
      expect(subject.job_id).to eq(params[:job_id])
      expect(subject.status).to eq(params[:status])
      expect(subject.external_reference).to eq(params[:external_reference])
      expect(subject.ad_description).to eq(params[:ad_description])
    end
  end
end
