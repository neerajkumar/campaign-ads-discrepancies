# frozen_string_literal: true

FactoryBot.define do
  factory :remote_ad, class: 'CampaignAdsDiscrepancies::RemoteAd' do
    reference { '1' }
    status { 'enabled' }
    description { 'Remote Ad Description' }

    initialize_with do
      new(
        reference: reference,
        status: status,
        description: description
      )
    end
  end
end
