@batch
Feature: ingest (cms) home health agency locations

  Background:
    Given the following documents exist in the '${constants.CMS_HHA_SOURCE}' collection:
    """
    [
      {
        CMS_Certification_Number_CCN: 'ccn-1',
        Provider_Name: 'provider-1',
        Address: 'address-1',
        City: 'city-1',
        State: 'state-1',
        Zip: 'zip-1',
        Phone: 'phone-1',
        Quality_of_Patient_Care_Star_Rating: 3.5,
        How_often_the_home_health_team_began_their_patients_care_in_a_timely_manner: 97.2,
        How_often_the_home_health_team_checked_patients_risk_of_falling: null,
        How_often_the_home_health_team_taught_patients_or_their_family_caregivers_about_their_drugs: 0,
        How_often_the_home_health_team_checked_patients_for_depression: 'Not Available',
        How_often_the_home_health_team_made_sure_that_their_patients_have_received_a_flu_shot_for_the_current_flu_season: 'A'
      }
    ]
    """
    And the following documents exist in the '${constants.GEO_ADDRESSES}' collection:
    """
    [
      {
        geoPoint: {
          type: 'Point',
          coordinates: [
            1.0,
            1.0
          ]
        },
        addressKey: 'address-1:city-1:state-1:zip-1'
      }
    ]
    """
    And the following documents exist in the '${constants.SPECIALTIES}' collection:
    """
    [
      {
        code: constants.HOME_HEALTH_SPECIALTY,
        grouping: 'grouping-1',
        classification: 'classification-1',
        specialization: 'specialization-1',
        system: 'system-1'
      }
    ]
    """

  Scenario: ingest cms-home-health-agency-locations
    When we run the '${BATCH}/cms-home-health-agency-locations' ingester
    Then mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.336:ccn-1:address-1:city-1:state-1:zip-1',
        organization: {
          _id: '4.336:ccn-1',
          id: {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'ccn-1',
          },
          name: 'provider-1',
          identifiers: [
            {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'ccn-1',
            }
          ]
        },
        address: {
          line1: 'address-1',
          city: 'city-1',
          state: 'state-1',
          zip: 'zip-1'
        },
        geoPoint: {
          type: 'Point',
          coordinates: [
            1.0,
            1.0
          ]
        },
        phone: 'phone-1',
        specialties: [
          {
            code: constants.HOME_HEALTH_SPECIALTY,
            classification: 'classification-1',
            specialization: 'specialization-1',
            system: 'system-1',
            grouping: 'grouping-1',
            isPrimary: true
          }
        ],
        ratings: [
          {
            score: 3.5,
              measure: {
                _id: 'cms:hhc:starRatings',
                name: 'Quality of Patient Care Star Rating',
                scale: 5
            }
          },
          {
            score: 97.2,
              measure: {
                _id: 'cms:hhc:timelyCare',
                name: 'How often the home health team began their patients care in a timely manner',
                scale: 100.0
            }
          },
          {
            score: 0,
              measure: {
                _id: 'cms:hhc:drugTeaching',
                name: 'How often the home health team taught patients or their family caregivers about their drugs',
                scale: 100.0
            }
          },
          {
            score: 'A',
              measure: {
                _id: 'cms:hhc:currentFluShot',
                name: 'How often the home health team made sure that their patients have received a flu shot for the current flu season',
                scale: 100.0
            }
          }
        ],
        created: {
          source: {_id: '-1', name: 'cms'},
          date: 'assert(actual.constructor.name == "Date")'
        },
        updated: {
          source: {_id: '-1', name: 'cms'},
          date: 'assert(actual.constructor.name == "Date")'
        }
      }
    ]
    """
