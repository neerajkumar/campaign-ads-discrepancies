# frozen_string_literal: true

module CampaignAdsDiscrepancies
  module DiscrepanciesServices
    class DiscrepanciesDetector < BaseService
      FILE_PATH = File.join(File.dirname(__FILE__), '../../../db/campaigns.csv')

      def call
        GetDiscrepancies.call(
          local_campaigns: local_campaigns,
          remote_campaigns: remote_campaigns
        )
      end

      private

      def local_campaigns
        CampaignsServices::GetCampaigns.call(FILE_PATH)
      end

      def remote_campaigns
        RemoteAdsServices::GetRemoteAds.call
      end
    end
  end
end
