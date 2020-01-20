module CampaignAdsDiscrepancies
  module CampaignsServices
    class GetCampaigns < BaseService

      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def call
        data = File.open(file_path) do |f|
          byebug
        end
      end
    end
  end
end
