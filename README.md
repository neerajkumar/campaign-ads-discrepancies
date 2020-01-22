# CampaignAdsDiscrepancies

[![Build Status](https://travis-ci.org/neerajkumar/campaign-ads-discrepancies.svg?branch=master)](https://travis-ci.org/neerajkumar/campaign-ads-discrepancies)

## Goal

Find discrepancies between campaigns (local ads) and remote ads.

## Task background

We publish our jobs to different marketing sources. To keep track of where the particular job is published, we create
`Campaign` entity in database. `Campaigns` are periodically synchronized with 3rd party _Ad Service_.

`Campaign` properties:

- `id`
- `job_id`
- `status`: one of [active, paused, deleted]
- `external_reference`: corresponds to Ad’s ‘reference’
- `ad_description`: text description of an Ad

Due to various types of failures (_Ad Service_ unavailability, errors in campaign details etc.)
local `Campaigns` can fall out of sync with _Ad Service_.
So we need a way to detect discrepancies between local and remote state.

## Assumptions


- Just for sake of simplicity, No DB used, but its loading data from a CSV file from db folder here.
- I have created various classes to follow the OOPs concept. `CampaignAdsDiscrepancies::DiscrepanciesServices::DiscrepanciesDetector` class is a high level class which is responsible to test overall functionality. Internally, this class calls all other classes and objects and return you the final result. `CampaignAdsDiscrepancies::DiscrepanciesServices::DiscrepanciesDetector` is only for better clarity and understanding.
- Not handling all kinds of external API errors.


## Output Format

### Discrepancies Not Found

```
[]
```

### Discrepancies Found

```
[
  {
    :remote_reference => "2",
    :discrepancies => [
      {
        "status" => {
          :remote => "disabled",
          :local => "paused"
        }
      }
    ]
  },
  {
    :remote_reference => "3",
    :discrepancies => [
      {
        "status" => {
          :remote => "enabled",
          :local => "deleted"
        },
        "description" => {
          :remote => "Description for campaign 13",
          :local => "Description for campaign 14"
        }
      }
    ]
  }
]
```


## Running Specs

Run `bundle exec rspec spec` from command line.

## Testing

Run `bundle exec rake console` to load entire application in IRB console. In IRB console, run

```
CampaignAdsDiscrepancies::DiscrepanciesServices::DiscrepanciesDetector.call
```

It will provide you all discrepancies found.

