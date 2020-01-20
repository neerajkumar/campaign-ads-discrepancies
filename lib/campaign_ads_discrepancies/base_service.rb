# frozen_string_literal: true

module CampaignAdsDiscrepancies
  class BaseService
    def self.call(*args)
      new(*args).call
    end
  end
end
