# frozen_string_literal: true

FactoryBot.define do
  factory :campaign, class: 'CampaignAdsDiscrepancies::Campaign' do
    id { 1 }
    job_id { 1 }
    status { 'active' }
    external_reference { '1' }
    ad_description { 'Ad Description' }

    initialize_with do
      new(
        id: id,
        job_id: job_id,
        status: status,
        external_reference: external_reference,
        ad_description: ad_description
      )
    end
  end
end
