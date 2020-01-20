# frozen_string_literal: true

require 'csv'

module CampaignAdsDiscrepancies
  module CampaignsServices
    class GetCampaigns < BaseService
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def call
        campaigns = []
        CSV.foreach(file_path, headers: true) do |row|
          campaigns << new_campaign(row)
        end
        campaigns
      end

      private

      def new_campaign(row)
        Campaign.new(
          id: row['id'],
          job_id: row['job_id'],
          external_reference: row['external_reference'],
          status: row['status'],
          ad_description: row['ad_description']
        )
      end
    end
  end
end
