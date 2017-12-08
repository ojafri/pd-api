@batch
Feature: ingest providers

  Background:
    Given the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: '4.6:npi-1:e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
        location: {
          _id: 'e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'e:pac:groupPac-1',
            id: {
              authority: 'pac',
              oid: 'pac',
              extension: 'groupPac-1',
            },
            name: 'orgName-1',
            identifiers: [
              {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1',
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
          phone: 'phone-1'
        },
        practitioner: {
          _id: '4.6:npi-1',
          id: {
            authority: 'npi',
            oid: '2.16.840.1.113883.4.6',
            extension: 'npi-1'
          },
          name: {
            first: 'firstName-1',
            last: 'lastName-1'
          },
          specialties: [
            {
              code: 'code-1',
              classification: 'classification-1',
              specialization: 'specialization-1',
              system: '2.16.840.1.113883.6.101',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              authority: 'npi',
              oid: '2.16.840.1.113883.4.6',
              extension: 'npi-1'
            }
          ]
        },
        created: {
          source: {_id: '-1', name: 'cms'},
          date: '2016-11-22T20:20:50.360+0000'
        },
        updated: {
          source: {_id: '-1', name: 'cms'},
          date: '2016-11-22T20:20:50.360+0000'
        }
      }
    ]
    """

  Scenario: ingest providers
    When we run the '${BATCH}/providers' ingester
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: '4.6:npi-1',
        id: {
          authority: 'npi',
          oid: '2.16.840.1.113883.4.6',
          extension: 'npi-1'
        },
        organizationRefs: [
          {
            _id: '4.6:npi-1:e:pac:groupPac-1',
            organization: {
              _id: 'e:pac:groupPac-1',
              name: 'orgName-1',
              locations: [
                {
                  _id: 'e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
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
                  phone: 'phone-1'
                }
              ]
            }
          }
        ],
        name: {
          first: 'firstName-1',
          last: 'lastName-1'
        },
        identifiers: [
          {
            authority: 'npi',
            oid: '2.16.840.1.113883.4.6',
            extension: 'npi-1'
          }
        ],
        specialties : [
          {
            code: 'code-1',
            classification: 'classification-1',
            specialization: 'specialization-1',
            system: '2.16.840.1.113883.6.101',
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
