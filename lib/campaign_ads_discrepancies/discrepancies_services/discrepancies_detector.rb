# frozen_string_literal: true

module CampaignAdsDiscrepancies
  module CampaignsServices
    class DiscrepanciesDetector < BaseService
      FILE_PATH = File.join(File.dirname(__FILE__), '../../../db/campaigns.csv')

      def call
        CampaignAdsDiscrepancies::CampaignsServices::GetDiscrepancies.call(
          local_campaigns: local_campaigns,
          remote_campaigns: remote_campaigns
        )
      end

      private

      def local_campaigns
        CampaignAdsDiscrepancies::CampaignsServices::GetCampaigns.call(FILE_PATH)
      end

      def remote_campaigns
        CampaignAdsDiscrepancies::RemoteAdsServices::GetRemoteAds.call
      end
    end
  end
end
