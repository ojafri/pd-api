@batch
Feature: ingest (cms) nursing home locations

  Background:
    Given the following documents exist in the '${constants.CMS_NURSING_HOME_SOURCE}' collection:
    """
    [
      {
        provnum: 'provnum-1',
        PROVNAME: 'provider-name-1',
        ADDRESS: 'address-1',
        CITY: 'city-1',
        STATE: 'state-1',
        ZIP: 'zip-1',
        PHONE: 'phone-1',
        overall_rating: 3,
        survey_rating: 4,
        quality_rating: 3,
        staffing_rating: 2,
        RN_staffing_rating: 1
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
        code: constants.NURSING_HOME_SPECIALTY,
        grouping: 'grouping-1',
        classification: 'classification-1',
        specialization: 'specialization-1',
        system: 'system-1'
      }
    ]
    """

  Scenario: ingest cms-nursing-home-locations
    When we run the '${BATCH}/cms-nursing-home-locations' ingester
    Then mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.336:provnum-1:address-1:city-1:state-1:zip-1',
        organization: {
          _id: '4.336:provnum-1',
          name: 'provider-name-1',
          id: {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provnum-1',
          },
          identifiers: [
            {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provnum-1',
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
            code: constants.NURSING_HOME_SPECIALTY,
            classification: 'classification-1',
            specialization: 'specialization-1',
            system: 'system-1',
            grouping: 'grouping-1',
            isPrimary: true
          }
        ],
        ratings: [
          {
            score: 3,
            measure: {
                _id: 'cms:nh:overall',
                name: 'Overall Rating',
                scale: 5
            }
          },
          {
            score: 4,
            measure: {
                _id: 'cms:nh:survey',
                name: 'Survey Rating',
                scale: 5
            }
          },
          {
            score: 3,
            measure: {
                _id: 'cms:nh:qualtiy',
                name: 'QM Rating',
                scale: 5
            }
          },
          {
            score: 2,
            measure: {
                _id: 'cms:nh:staffing',
                name: 'Staffing Rating',
                scale: 5
            }
          },
          {
            score: 1,
            measure: {
                _id: 'cms:nh:rn_staffing',
                name: 'RN Staffing Rating',
                scale: 5
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
