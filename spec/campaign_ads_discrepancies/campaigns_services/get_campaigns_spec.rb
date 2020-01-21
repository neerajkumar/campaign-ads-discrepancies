# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::CampaignsServices::GetCampaigns do
  let(:tempfile) { Tempfile.new('campaigns.csv') }

  after { tempfile.unlink }

  describe '#initialize' do
    subject { described_class.new(tempfile.path) }

    it 'returns an instance of CampaignAdsDiscrepancies::CampaignsServices::GetCampaigns class' do
      expect(subject).to be_an_instance_of(described_class)
    end

    it 'returns file_path attribute of CampaignAdsDiscrepancies::CampaignsServices::GetCampaigns object' do
      expect(subject.file_path).to eq(tempfile.path)
    end
  end

  describe '#call' do
    before do
      tempfile.write("id,job_id,external_reference,status,ad_description\n")
      tempfile.write('1,100,1,active,Description for campaign 11')
      tempfile.close
    end

    subject { described_class.call(tempfile.path) }

    it 'returns collection of campaign objects' do
      expect(subject).not_to be_empty
      expect(subject).to be_a_kind_of(Array)
      expect(subject.size).to eq(1)
      expect(subject[0]).to be_an_instance_of(CampaignAdsDiscrepancies::Campaign)
    end
  end
end
