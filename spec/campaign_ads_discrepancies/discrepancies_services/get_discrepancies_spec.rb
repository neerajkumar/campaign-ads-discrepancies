# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CampaignAdsDiscrepancies::DiscrepanciesServices::GetDiscrepancies do
  let(:campaign) { build(:campaign) }
  let(:remote_ad) { build(:remote_ad) }

  describe '#initialize' do
    subject { described_class.new(local_campaigns: [campaign], remote_campaigns: [remote_ad]) }

    it 'returns an instance of CampaignAdsDiscrepancies::DiscrepanciesServices::GetDiscrepancies class' do
      expect(subject).to be_an_instance_of(described_class)
    end

    it 'returns attributes of CampaignAdsDiscrepancies::DiscrepanciesServices::GetDiscrepancies object' do
      expect(subject.local_campaigns).to eq([campaign])
      expect(subject.remote_campaigns).to eq([remote_ad])
    end
  end

  describe '#call' do
    context 'when local campaigns not present' do
      subject { described_class.call(local_campaigns: [], remote_campaigns: [remote_ad]) }

      it 'return empty array' do
        expect(subject).to be_empty
        expect(subject).to be_kind_of(Array)
      end
    end

    context 'when remote campaigns not present' do
      subject { described_class.call(local_campaigns: [campaign], remote_campaigns: []) }

      it 'return empty array' do
        expect(subject).to be_empty
        expect(subject).to be_kind_of(Array)
      end
    end

    context 'when local campaigns and remote campaigns both present' do
      subject { described_class.call(local_campaigns: [campaign], remote_campaigns: [remote_ad]) }

      context "when campaign and remote ad reference doesn't match" do
        let(:remote_ad) do
          build(
            :remote_ad,
            reference: '2',
            status: described_class::STATUS_MAPPING[campaign.status.to_sym],
            description: campaign.ad_description
          )
        end

        it 'returns no result' do
          expect(subject).to be_empty
          expect(subject).to be_kind_of(Array)
        end
      end

      context 'when no discrepency found' do
        let(:remote_ad) do
          build(
            :remote_ad,
            reference: campaign.external_reference,
            status: described_class::STATUS_MAPPING[campaign.status.to_sym],
            description: campaign.ad_description
          )
        end

        it 'returns no result' do
          expect(subject).to be_empty
          expect(subject).to be_kind_of(Array)
        end
      end

      context 'when only status field discrepancy found' do
        let(:remote_ad) do
          build(
            :remote_ad,
            reference: campaign.external_reference,
            status: 'paused',
            description: campaign.ad_description
          )
        end

        it 'returns discrepancies with status field only' do
          expect(subject).not_to be_empty
          expect(subject.size).to eq(1)
          expect(subject[0][:discrepancies][0]['status']).to include(remote: remote_ad.status, local: campaign.status)
          expect(subject[0][:discrepancies][0]['description']).to be_nil
        end
      end

      context 'when only description field discrepancy found' do
        let(:remote_ad) do
          build(
            :remote_ad,
            reference: campaign.external_reference,
            status: described_class::STATUS_MAPPING[campaign.status.to_sym]
          )
        end

        it 'returns discrepancies with description field only' do
          expect(subject).not_to be_empty
          expect(subject.size).to eq(1)
          expect(subject[0][:discrepancies][0]['description']).to include(remote: remote_ad.description, local: campaign.ad_description)
          expect(subject[0][:discrepancies][0]['status']).to be_nil
        end
      end

      context 'when both status and description fields discrepancies found' do
        let(:remote_ad) do
          build(
            :remote_ad,
            reference: campaign.external_reference,
            status: 'deleted'
          )
        end

        it 'returns discrepancies with status and description fields both' do
          expect(subject).not_to be_empty
          expect(subject.size).to eq(1)
          expect(subject[0][:discrepancies][0]['status']).not_to be_nil
          expect(subject[0][:discrepancies][0]['status']).to include(remote: remote_ad.status, local: campaign.status)
          expect(subject[0][:discrepancies][0]['description']).not_to be_nil
          expect(subject[0][:discrepancies][0]['description']).to include(remote: remote_ad.description, local: campaign.ad_description)
        end
      end
    end
  end
end
