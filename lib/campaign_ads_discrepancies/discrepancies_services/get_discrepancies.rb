# frozen_string_literal: true

module CampaignAdsDiscrepancies
  module CampaignsServices
    class GetDiscrepancies < BaseService
      attr_reader :local_campaigns, :remote_campaigns

      STATUS_MAPPING = {
        active: 'enabled',
        paused: 'enabled',
        deleted: 'disabled'
      }.freeze

      def initialize(local_campaigns:, remote_campaigns:)
        @local_campaigns = local_campaigns
        @remote_campaigns = remote_campaigns
      end

      def call
        return [] if local_campaigns.empty? || remote_campaigns.empty?

        local_campaigns.each_with_object([]) do |local_campaign, discrepancies|
          remote_campaign = remote_campaign(local_campaign)
          next unless remote_campaign

          if discrepancy_found?(local_campaign, remote_campaign)
            discrepancies << discrepancy(local_campaign, remote_campaign)
          end
        end
      end

      private

      def remote_campaign(local_campaign)
        remote_campaigns.detect { |campaign| campaign.reference.to_i == local_campaign.external_reference.to_i }
      end

      def discrepancy_found?(local_campaign, remote_campaign)
        local_campaign.ad_description != remote_campaign.description ||
          STATUS_MAPPING[local_campaign.status.to_sym] != remote_campaign.status
      end

      def discrepancy(local_campaign, remote_campaign)
        {
          remote_reference: remote_campaign.reference,
          discrepancies: [
            status: {
              remote: remote_campaign.status,
              local: local_campaign.status
            },
            description: {
              remote: remote_campaign.description,
              local: local_campaign.ad_description
            }
          ]
        }
      end
    end
  end
end
