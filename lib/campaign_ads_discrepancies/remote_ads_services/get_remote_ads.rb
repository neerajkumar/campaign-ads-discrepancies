# frozen_string_literal: true

require 'net/http'
require 'json'

module CampaignAdsDiscrepancies
  module RemoteAdsServices
    class GetRemoteAds < BaseService
      REMOTE_ADS_URL = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'

      attr_reader :remote_url

      def initialize
        @remote_url = URI(ENV['REMOTE_URL'] || REMOTE_ADS_URL)
      end

      def call
        response = Net::HTTP.get(remote_url)
        ads = JSON.parse(response)['ads']
        ads.map { |ad| new_remote_ad(ad) }
      rescue SocketError
        nil
      end

      private

      def new_remote_ad(ad_params)
        RemoteAd.new(
          reference: ad_params['reference'],
          status: ad_params['status'],
          description: ad_params['description']
        )
      end
    end
  end
end
