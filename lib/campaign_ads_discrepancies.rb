# frozen_string_literal: true

Dir[File.join('.', 'lib/campaign_ads_discrepancies/**/*.rb')].sort.each do |f|
  require f
end

require 'dotenv/load'

module CampaignAdsDiscrepancies
end
