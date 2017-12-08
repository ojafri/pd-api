@batch
Feature: client provider locations
  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne'
      },
      {
        _id: 'c2',
        name: 'ceeTwo'
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1',
        id: {
          authority: 'auth-1',
          oid: 'org-oid-1',
          extension: 'org-ext-1'
        },
        name: 'name-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          }
        ],
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        locations: [
          {
            _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
            address: {
              line1: 'street-1',
              line2: 'unit-1',
              city: 'city-1',
              state: 's1',
              zip: 'zip-1'
            },
            geoPoint: {
              type: 'Point',
              coordinates: [0.111, 0.111]
            },
            phone: 'phone-1111'
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'org-oid-1',
            extension: 'org-ext-1'
          }
        ],
        created: {
          source: {
            _id: 'c1'
          }
        },
        isPrivate: true
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          }
        ],
        address: {
          line1: 'street-1',
          line2: 'unit-1',
          city: 'city-1',
          state: 's1',
          zip: 'zip-1'
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.111, 0.111]
        },
        organization: {
          _id: 'e:org-oid-1:org-ext-1',
          name: 'name-1',
          id: {
            oid: 'org-oid-1',
            authority: 'auth-1',
            extension: 'org-ext-1'
          }
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        phone: 'phone-1111',
        fax: 'fax-111111',
        county: 'county-1',
        hours: 'hours-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'e:prov-oid-1:prov-ext-1',
        organizationRefs: [
          {
            organization: {
              _id: 'e:org-oid-1:org-ext-1',
              locations: [
                {
                  _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
                  address: {
                    line1: 'street-1',
                    line2: 'unit-1',
                    city: 'city-1',
                    state: 's1',
                    zip: 'zip-1'
                  },
                  geoPoint: {
                    type: 'Point',
                    coordinates: [0.111, 0.111]
                  },
                  phone: 'phone-1111'
                }
              ]
            }
          }
        ],
        id: {
          authority: 'auth-1',
          oid: 'prov-oid-1',
          extension: 'prov-ext-1'
        },
        name: {
          first: 'first-1',
          last: 'last-1'
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'prov-oid-1',
            extension: 'prov-ext-1'
          }
        ],
        created: {
          source: {
            _id: 'c1'
          }
        },
        isPrivate : true
      },
      {
        _id: 'e:prov-oid-2:prov-ext-2',
        organizationRefs: [
          {
            organization: {
              _id: 'e:org-oid-1:org-ext-1',
              locations: [
                {
                  _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
                  address: {
                    line1: 'street-1',
                    line2: 'unit-1',
                    city: 'city-1',
                    state: 's1',
                    zip: 'zip-1'
                  },
                  geoPoint: {
                    type: 'Point',
                    coordinates: [0.111, 0.111]
                  },
                  phone: 'phone-1111'
                }
              ]
            }
          }
        ],
        id: {
          authority: 'auth-2',
          oid: 'prov-oid-2',
          extension: 'prov-ext-2'
        },
        name: {
          first: 'first-2',
          last: 'last-2'
        },
        specialties: [
          {
            code: 'code-2',
            classification: 'class-2',
            specialization: 'spec-2',
            system: 'sys-2',
            isPrimary: true
          }
        ],
        identifiers: [
          {
            authority: 'auth-2',
            oid: 'prov-oid-2',
            extension: 'prov-ext-2'
          }
        ],
        created: {
          source: {
            _id: 'c1'
          }
        },
        isPrivate : true
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-1',
        practitioner: {
          _id: 'e:prov-oid-2:prov-ext-2',
          id: {
            authority: 'auth-2',
            oid: 'prov-oid-2',
            extension: 'prov-ext-2'
          },
          name: {
            first: 'first-2',
            last: 'last-2'
          },
          specialties: [
            {
              code: 'code-2',
              classification: 'class-2',
              specialization: 'spec-2',
              system: 'sys-2',
              isPrimary: true
            }
          ],
          identifiers: [
            {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            }
          ]
        },
        location: {
          _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
          organization: {
            _id: 'e:org-oid-1:org-ext-1',
            name: 'name-1',
            id: {
              oid: 'org-oid-1',
              authority: 'auth-1',
              extension: 'org-ext-1'
            }
          },
          address: {
            line1: 'street-1',
            line2: 'unit-1',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          }
        },
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-provider-locations: insert
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        recordId: null,
        providerOid: 'prov-oid-1',
        providerExtension: 'prov-ext-1',
        orgOid: 'org-oid-1',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-1',
        isInactive: true,
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{_id: 'e:prov-oid-1:prov-ext-1:e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:prov-oid-1:prov-ext-1:e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
        location: {
          _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
          organization: {
            _id: 'e:org-oid-1:org-ext-1',
            name: 'name-1',
            id: {
              oid: 'org-oid-1',
              authority: 'auth-1',
              extension: 'org-ext-1'
            }
          },
          address: {
            line2: 'unit-1',
            line1: 'street-1',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          },
          phone: 'phone-1111'
        },
        hours: 'hours-1',
        isInactive: true,
        practitioner: {
          _id: 'e:prov-oid-1:prov-ext-1',
          id: {
            authority: 'auth-1',
            oid: 'prov-oid-1',
            extension: 'prov-ext-1'
          },
          name: {
            first: 'first-1',
            last: 'last-1'
          },
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            }
          ],
          specialties: [
            {
              code: 'code-1',
              classification: 'class-1',
              specialization: 'spec-1',
              system: 'sys-1',
              isPrimary: true
            }
          ]
        },
        created: {
          source: {_id: 'c1', name: 'ceeOne'},
          date: 'assert(actual.constructor.name == "Date")'
        },
        updated: {
          source: {_id: 'c1', name: 'ceeOne'},
          date: 'assert(actual.constructor.name == "Date")'
        },
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:org-oid-1:org-ext-1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1',
        id: {
          authority: 'auth-1',
          oid: 'org-oid-1',
          extension: 'org-ext-1'
        },
        name: 'name-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          },
          {
            _id: 'e:prov-oid-1:prov-ext-1',
            id: {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            },
            name: {
              first: 'first-1',
              last: 'last-1'
            }
          }
        ],
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        locations: [
          {
            _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
            address: {
              line1: 'street-1',
              line2: 'unit-1',
              city: 'city-1',
              state: 's1',
              zip: 'zip-1'
            },
            geoPoint: {
              type: 'Point',
              coordinates: [0.111, 0.111]
            },
            phone: 'phone-1111'
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'org-oid-1',
            extension: 'org-ext-1'
          }
        ],
        created: {
          source: {
            _id: 'c1'
          }
        },
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          },
          {
            _id: 'e:prov-oid-1:prov-ext-1',
            id: {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            },
            name: {
              first: 'first-1',
              last: 'last-1'
            }
          }
        ],
        address: {
          line1: 'street-1',
          line2: 'unit-1',
          city: 'city-1',
          state: 's1',
          zip: 'zip-1'
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.111, 0.111]
        },
        organization: {
          _id: 'e:org-oid-1:org-ext-1',
          name: 'name-1',
          id: {
            oid: 'org-oid-1',
            authority: 'auth-1',
            extension: 'org-ext-1'
          }
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        phone: 'phone-1111',
        fax: 'fax-111111',
        county: 'county-1',
        hours: 'hours-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-provider-locations: insert: record-id
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        recordId: 'rid-2',
        providerOid: 'prov-oid-1',
        providerExtension: 'prov-ext-1',
        orgOid: 'org-oid-1',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-1',
        isInactive: true,
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{_id: 'c1:rid-2'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-2',
        location: {
          _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
          organization: {
            _id: 'e:org-oid-1:org-ext-1',
            name: 'name-1',
            id: {
              oid: 'org-oid-1',
              authority: 'auth-1',
              extension: 'org-ext-1'
            }
          },
          address: {
            line2: 'unit-1',
            line1: 'street-1',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          }
        },
        hours: 'hours-1',
        isInactive: true,
        practitioner: {
          _id: 'e:prov-oid-1:prov-ext-1',
          id: {
            authority: 'auth-1',
            oid: 'prov-oid-1',
            extension: 'prov-ext-1'
          },
          name: {
            first: 'first-1',
            last: 'last-1'
          },
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            }
          ],
          specialties: [
            {
              code: 'code-1',
              classification: 'class-1',
              specialization: 'spec-1',
              system: 'sys-1',
              isPrimary: true
            }
          ]
        },
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:org-oid-1:org-ext-1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1',
        id: {
          authority: 'auth-1',
          oid: 'org-oid-1',
          extension: 'org-ext-1'
        },
        name: 'name-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          },
          {
            _id: 'e:prov-oid-1:prov-ext-1',
            id: {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            },
            name: {
              first: 'first-1',
              last: 'last-1'
            }
          }
        ],
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        locations: [
          {
            _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
            address: {
              line1: 'street-1',
              line2: 'unit-1',
              city: 'city-1',
              state: 's1',
              zip: 'zip-1'
            },
            geoPoint: {
              type: 'Point',
              coordinates: [0.111, 0.111]
            },
            phone: 'phone-1111'
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'org-oid-1',
            extension: 'org-ext-1'
          }
        ],
        created: {
          source: {
            _id: 'c1'
          }
        },
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
        practitioners: [
          {
            _id: 'e:prov-oid-2:prov-ext-2',
            id: {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            },
            name: {
              first: 'first-2',
              last: 'last-2'
            }
          },
          {
            _id: 'e:prov-oid-1:prov-ext-1',
            id: {
              authority: 'auth-1',
              oid: 'prov-oid-1',
              extension: 'prov-ext-1'
            },
            name: {
              first: 'first-1',
              last: 'last-1'
            }
          }
        ],
        address: {
          line1: 'street-1',
          line2: 'unit-1',
          city: 'city-1',
          state: 's1',
          zip: 'zip-1'
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.111, 0.111]
        },
        organization: {
          _id: 'e:org-oid-1:org-ext-1',
          name: 'name-1',
          id: {
            oid: 'org-oid-1',
            authority: 'auth-1',
            extension: 'org-ext-1'
          }
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          }
        ],
        phone: 'phone-1111',
        fax: 'fax-111111',
        county: 'county-1',
        hours: 'hours-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-provider-locations: update
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        providerOid: 'prov-oid-2',
        providerExtension: 'prov-ext-2',
        orgOid: 'org-oid-1',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-5',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {updated: 1}
    }
    """
    And mongo query "{_id: 'c1:rid-1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        location: {
          _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
          organization: {
            _id: 'e:org-oid-1:org-ext-1',
            name: 'name-1',
            id: {
              oid: 'org-oid-1',
              authority: 'auth-1',
              extension: 'org-ext-1'
            }
          },
          address: {
            line1: 'street-1',
            line2: 'unit-1',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          }
        },
        hours: 'hours-5',
        practitioner: {
          _id: 'e:prov-oid-2:prov-ext-2',
          id: {
            authority: 'auth-2',
            oid: 'prov-oid-2',
            extension: 'prov-ext-2'
          },
          name: {
            first: 'first-2',
            last: 'last-2'
          },
          identifiers: [
            {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            }
          ],
          specialties: [
            {
              code: 'code-2',
              classification: 'class-2',
              specialization: 'spec-2',
              system: 'sys-2',
              isPrimary: true
            }
          ]
        },
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-provider-locations: update: record-id
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        recordId: 'rid-1',
        providerOid: 'prov-oid-2',
        providerExtension: 'prov-ext-2',
        orgOid: 'org-oid-1',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-0',
        isInactive: true,
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {updated: 1}
    }
    """
    And mongo query "{_id: 'c1:rid-1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        location: {
          _id: 'e:org-oid-1:org-ext-1:street-1:city-1:s1:zip-1',
          organization: {
            _id: 'e:org-oid-1:org-ext-1',
            name: 'name-1',
            id: {
              oid: 'org-oid-1',
              authority: 'auth-1',
              extension: 'org-ext-1'
            }
          },
          address: {
            line1: 'street-1',
            line2: 'unit-1',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          }
        },
        hours: 'hours-0',
        practitioner: {
          _id: 'e:prov-oid-2:prov-ext-2',
          id: {
            authority: 'auth-2',
            oid: 'prov-oid-2',
            extension: 'prov-ext-2'
          },
          name: {
            first: 'first-2',
            last: 'last-2'
          },
          identifiers: [
            {
              authority: 'auth-2',
              oid: 'prov-oid-2',
              extension: 'prov-ext-2'
            }
          ],
          specialties: [
            {
              code: 'code-2',
              classification: 'class-2',
              specialization: 'spec-2',
              system: 'sys-2',
              isPrimary: true
            }
          ]
        },
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-provider-locations: update: non-existent-provider
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        providerOid: 'non-existent',
        providerExtension: 'prov-ext-1',
        orgOid: 'org-oid-1',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-1',
        isInactive: true,
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {failed: 1}
    }
    """

  Scenario: ingest client-provider-locations: update: non-existent-organization
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        providerOid: 'prov-oid-1',
        providerExtension: 'prov-ext-1',
        orgOid: 'non-existent',
        orgExtension: 'org-ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        hours: 'hours-1',
        isInactive: true,
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-provider-locations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {failed: 1}
    }
    """
