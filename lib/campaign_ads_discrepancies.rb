Dir[File.join('.', 'lib/campaign_ads_discrepancies/**/*.rb')].each { |file| require(file) }
require 'byebug'

module CampaignAdsDiscrepancies
end
