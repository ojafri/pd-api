@batch
Feature: ingest (cms) dialysis facility locations

  Background:
    Given the following documents exist in the '${constants.CMS_DIALYSIS_FACILITY_SOURCE}' collection:
    """
    [
      {
        Provider_number: 'provider-1',
        Facility_name: 'facility-1',
        Address_line_1: 'addressLine1-1',
        City: 'city-1',
        STATE: 'state-1',
        Zip: 'zip-1',
        County: 'county-1',
        Phone_number: 'phone-1',
        Five_star: 3,
        Five_star_date: '01/01/2012-12/31/2015',
        Five_star_data_availability_code: '001'
      },
      {
        Provider_number: 'provider-2',
        Facility_name: 'facility-2',
        Address_line_1: 'addressLine1-1',
        City: 'city-1',
        STATE: 'state-1',
        Zip: 'zip-1',
        County: 'county-1',
        Phone_number: 'phone-1'
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
        addressKey: 'addressLine1-1:city-1:state-1:zip-1'
      }
    ]
    """
    And the following documents exist in the '${constants.SPECIALTIES}' collection:
    """
    [
      {
        code: constants.DIALYSIS_FACILITY_SPECIALTY,
        grouping: 'grouping-1',
        classification: 'classification-1',
        specialization: 'specialization-1',
        system: 'system-1'
      }
    ]
    """

  Scenario: ingest cms-dialysis-facility-locations
    When we run the '${BATCH}/cms-dialysis-facility-locations' ingester
    Then mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.336:provider-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: '4.336:provider-1',
          id: {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-1',
          },
          name: 'facility-1',
          identifiers: [
            {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-1',
            }
          ]
        },
        address: {
          line1: 'addressLine1-1',
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
            code: constants.DIALYSIS_FACILITY_SPECIALTY,
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
                _id: 'cms:df:fiveStar',
                name: 'Five Star Rating',
                scale: 5
            },
            fromDate: '01/01/2012',
            toDate: '12/31/2015'
          }
        ],
        created: {
          date: 'assert(actual.constructor.name == "Date")'
        },
        updated: {
          date: 'assert(actual.constructor.name == "Date")'
        }
      },
      {
        _id: '4.336:provider-2:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: '4.336:provider-2',
          id: {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-2',
          },
          name: 'facility-2',
          identifiers: [
            {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-2',
            }
          ]
        },
        address: {
          line1: 'addressLine1-1',
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
            code: constants.DIALYSIS_FACILITY_SPECIALTY,
            classification: 'classification-1',
            specialization: 'specialization-1',
            system: 'system-1',
            grouping: 'grouping-1',
            isPrimary: true
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
