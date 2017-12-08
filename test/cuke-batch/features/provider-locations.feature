@batch
Feature: ingest provider locations

  Background:
    Given the following documents exist in the '${constants.NPI_PROVIDERS}' collection:
    """
    [
      {
        npi: 'npi-1',
        specialties: [
          {
            code: 'code-1',
            isPrimary: true
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.SPECIALTIES}' collection:
    """
    [
      {
        code: 'code-1',
        grouping: 'grouping-1',
        classification: 'classification-1',
        specialization: 'specialization-1',
        system: 'system-1'
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

  Scenario: ingest provider-locations
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        orgName: 'orgName-1',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
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
              extension: 'groupPac-1'
            },
            name: 'orgName-1',
            identifiers: [
              {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1'
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
            oid: '2.16.840.1.113883.4.6',
            authority: 'npi',
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
              system: 'system-1',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              oid: '2.16.840.1.113883.4.6',
              authority: 'npi',
              extension: 'npi-1'
            }
          ]
        },
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

  Scenario: update community claimed record
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        orgName: 'orgName-1',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    Given the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: '4.6:npi-1:e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
        updated: {
          source: {
            _id: '1'
          }
        }
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 0, updated: 0, failed: 1, scanned: 0}
    }
    """

  Scenario: ingest provider-locations with no organization name
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.6:npi-1:e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
        location: {
          _id: 'e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'e:pac:groupPac-1',
            name: 'lastName-1, firstName-1'
          }
        }
      }
    ]
    """

  Scenario: ingest provider-locations with no organization name and middle name
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        middleName: 'middleName-1',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.6:npi-1:e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
        location: {
          _id: 'e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'e:pac:groupPac-1',
            name: 'lastName-1, firstName-1 middleName-1'
          }
        }
      }
    ]
    """

  Scenario: ingest provider-locations with no organization name or group-pac
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: '4.6:npi-1:4.6:npi-1:addressLine1-1:city-1:state-1:zip-1',
        location: {
          _id: '4.6:npi-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: '4.6:npi-1',
            name: 'lastName-1, firstName-1'
          }
        }
      }
    ]
    """

  Scenario: no-op existing record
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-1',
        firstName: 'firstName-1',
        orgName: 'orgName-1',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-1',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-1'
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
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
              extension: 'groupPac-1'
            },
            name: 'orgName-1',
            identifiers: [
              {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1'
              }
            ]
          },
          address: {
            line1: 'addressLine1-1',
            line2: 'addressLine2-1',
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
            oid: '2.16.840.1.113883.4.6',
            authority: 'npi',
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
              system: 'system-1',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              oid: '2.16.840.1.113883.4.6',
              authority: 'npi',
              extension: 'npi-1'
            }
          ]
        },
        created: {
          source: {_id: '-1', name: 'cms'}
        },
        updated: {
          source: {_id: '-1', name: 'cms'}
        }
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 0, updated: 0, failed: 0, scanned: 1}
    }
    """

  Scenario: update existing record
    Given the following documents exist in the '${constants.CMS_PROVIDER_SOURCE}' collection:
    """
    [
      {
        npi: 'npi-1',
        lastName: 'lastName-2',
        firstName: 'firstName-2',
        orgName: 'orgName-2',
        groupPac: 'groupPac-1',
        addressLine1: 'addressLine1-1',
        addressLine2: 'addressLine2-2',
        city: 'city-1',
        state: 'state-1',
        zip: 'zip-1',
        phone: 'phone-2'
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
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
              extension: 'groupPac-1'
            },
            name: 'orgName-1',
            identifiers: [
              {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1'
              }
            ]
          },
          address: {
            line1: 'addressLine1-1',
            line2: 'addressLine2-1',
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
            oid: '2.16.840.1.113883.4.6',
            authority: 'npi',
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
              system: 'system-1',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              oid: '2.16.840.1.113883.4.6',
              authority: 'npi',
              extension: 'npi-1'
            }
          ]
        },
        created: {
          source: {_id: '-1', name: 'cms'},
          date: new Date()
        },
        updated: {
          source: {_id: '-1', name: 'cms'},
          date: new Date()
        }
      }
    ]
    """
    When we run the '${BATCH}/provider-locations' ingester
    Then our resultant state should be like:
    """
    {
      result: {inserted: 0, updated: 1, failed: 0, scanned: 0}
    }
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
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
              extension: 'groupPac-1'
            },
            name: 'orgName-2',
            identifiers: [
              {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1'
              }
            ]
          },
          address: {
            line1: 'addressLine1-1',
            city: 'city-1',
            state: 'state-1',
            zip: 'zip-1',
            line2: 'addressLine2-2'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [
              1.0,
              1.0
            ]
          },
          phone: 'phone-2'
        },
        practitioner: {
          _id: '4.6:npi-1',
          id: {
            oid: '2.16.840.1.113883.4.6',
            authority: 'npi',
            extension: 'npi-1'
          },
          name: {
            first: 'firstName-2',
            last: 'lastName-2'
          },
          specialties: [
            {
              code: 'code-1',
              classification: 'classification-1',
              specialization: 'specialization-1',
              system: 'system-1',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              oid: '2.16.840.1.113883.4.6',
              authority: 'npi',
              extension: 'npi-1'
            }
          ]
        },
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
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}History' should be like:
    """
    [
      {
        data: {
          _id: '4.6:npi-1:e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
          location: {
            _id: 'e:pac:groupPac-1:addressLine1-1:city-1:state-1:zip-1',
            organization: {
              _id: 'e:pac:groupPac-1',
              id: {
                authority: 'pac',
                oid: 'pac',
                extension: 'groupPac-1'
              },
              name: 'orgName-1',
              identifiers: [
                {
                  authority: 'pac',
                  oid: 'pac',
                  extension: 'groupPac-1'
                }
              ]
            },
            address: {
              line1: 'addressLine1-1',
              city: 'city-1',
              state: 'state-1',
              zip: 'zip-1',
              line2: 'addressLine2-1'
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
              oid: '2.16.840.1.113883.4.6',
              authority: 'npi',
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
                system: 'system-1',
                isPrimary: true
              }
            ],
            identifiers: [
              {
                oid: '2.16.840.1.113883.4.6',
                authority: 'npi',
                extension: 'npi-1'
              }
            ]
          },
          created: {
            source: {_id: '-1', name: 'cms'},
            date: 'assert(actual.constructor.name == "Date")'
          },
          updated: {
            source: {_id: '-1', name: 'cms'},
            date: 'assert(actual.constructor.name == "Date")'
          }
        }
      }
    ]
    """
