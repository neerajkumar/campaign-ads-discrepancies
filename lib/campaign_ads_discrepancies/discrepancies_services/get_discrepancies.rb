# frozen_string_literal: true

module CampaignAdsDiscrepancies
  module CampaignsServices
    class GetDiscrepancies < BaseService
      attr_reader :local_campaigns, :remote_campaigns

      COMPARED_ATTRIBUTES = %w[status description].freeze

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

        local_campaigns.each_with_object([]) do |local_campaign, result|
          remote_campaign = remote_campaign(local_campaign)
          next unless remote_campaign

          discrepancy = discrepancy(local_campaign, remote_campaign)

          result << discrepancy if discrepancy
        end
      end

      private

      def remote_campaign(local_campaign)
        remote_campaigns.detect { |campaign| campaign.reference.to_i == local_campaign.external_reference.to_i }
      end

      def discrepancy(local_campaign, remote_campaign)
        return [] unless remote_campaign

        discrepancies = discrepancies(local_campaign, remote_campaign)
        return if discrepancies.empty?

        {
          remote_reference: remote_campaign.reference,
          discrepancies: [discrepancies]
        }
      end

      def discrepancies(local_campaign, remote_campaign)
        COMPARED_ATTRIBUTES.each_with_object({}) do |attr, result|
          discrepancy = send("#{attr}_discrepancy", local_campaign, remote_campaign)
          next unless discrepancy

          result[attr] = discrepancy
        end
      end

      def status_discrepancy(local_campaign, remote_campaign)
        return if STATUS_MAPPING[local_campaign.status.to_sym] == remote_campaign.status

        {
          remote: remote_campaign.status,
          local: local_campaign.status
        }
      end

      def description_discrepancy(local_campaign, remote_campaign)
        return if local_campaign.ad_description == remote_campaign.description

        {
          remote: remote_campaign.description,
          local: local_campaign.ad_description
        }
      end
    end
  end
end
