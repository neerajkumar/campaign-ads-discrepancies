# frozen_string_literal: true

module CampaignAdsDiscrepancies
  class Campaign
    attr_reader :id, :job_id, :status, :external_reference, :ad_description

    def initialize(id:, job_id:, status:, external_reference:, ad_description:)
      @id = id
      @job_id = job_id
      @status = status
      @external_reference = external_reference
      @ad_description = ad_description
    end
  end
end
