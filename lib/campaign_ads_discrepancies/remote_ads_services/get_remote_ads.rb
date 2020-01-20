# frozen_string_literal: true

require 'net/http'
require 'json'

module CampaignAdsDiscrepancies
  module RemoteAdsServices
    class GetRemoteAds < CampaignAdsDiscrepancies::BaseService
      REMOTE_ADS_URL = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'

      attr_reader :remote_url

      def initialize
        @remote_url = URI(REMOTE_ADS_URL)
      end

      def call
        response = Net::HTTP.get(remote_url)
        ads = JSON.parse(response)['ads']
        ads.map do |ad|
          RemoteAd.new(
            reference: ad['reference'],
            status: ad['status'],
            description: ad['description']
          )
        end
      end
    end
  end
end
