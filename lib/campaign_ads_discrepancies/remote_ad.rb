# frozen_string_literal: true

module CampaignAdsDiscrepancies
  class RemoteAd
    attr_reader :reference, :status, :description

    def initialize(reference:, status:, description:)
      @reference = reference
      @status = status
      @description = description
    end
  end
end
