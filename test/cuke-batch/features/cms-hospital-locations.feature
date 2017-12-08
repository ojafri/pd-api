@batch
Feature: ingest (cms) hospital locations

  Background:
    Given the following documents exist in the '${constants.CMS_HOSPITAL_SOURCE}' collection:
    """
    [
      {
        Provider_ID: 'provider-1',
        Hospital_Name: 'hospital-name-1',
        Address: 'address-1',
        City: 'city-1',
        State: 'state-1',
        ZIP_Code: 'zip-1',
        Phone_Number: 'phone-1',
        Hospital_overall_rating: 3
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
        code: constants.HOSPITAL_SPECIALTY,
        grouping: 'grouping-1',
        classification: 'classification-1',
        specialization: 'specialization-1',
        system: 'system-1'
      }
    ]
    """

  Scenario: ingest cms-hospital-locations
    When we run the '${BATCH}/cms-hospital-locations' ingester
    Then mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.336:provider-1:address-1:city-1:state-1:zip-1',
        organization: {
          _id: '4.336:provider-1',
          name: 'hospital-name-1',
          id: {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-1',
          },
          identifiers: [
            {
              authority: 'ccn',
              oid: '2.16.840.1.113883.4.336',
              extension: 'provider-1',
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
            code: constants.HOSPITAL_SPECIALTY,
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
                _id: 'cms:hpl:overall',
                name: 'Overall Rating',
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
