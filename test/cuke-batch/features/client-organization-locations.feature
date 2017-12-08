@batch
Feature: client organization locations
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
    And the following documents exist in the '${constants.GEO_ADDRESSES}' collection:
    """
    [
      {
        geoPoint: {
          type: 'Point',
          coordinates: [0.111, 0.111]
        },
        addressKey: 'street-1:city-1:s1:zip-1'
      },
      {
        geoPoint: {
          type: 'Point',
          coordinates: [0.222, 0.222]
        },
        addressKey: 'street-2:city-2:s2:zip-2'
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        name: 'name-1',
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
            _id: 'c1:rid-1',
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
            oid: 'oid-1',
            extension: 'ext-1'
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
        _id: 'c1:rid-1',
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
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            oid: 'oid-1',
            authority: 'auth-1',
            extension: 'ext-1'
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
        isPrivate: true,
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        organizationRefs: [
          {
            organization: {
              _id: 'e:oid-1:ext-1',
              locations: [
                {
                  _id: 'c1:rid-1',
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
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        location: {
          _id: 'c1:rid-1',
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
      }
    ]
    """

  Scenario: ingest client-organization-locations: insert
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        addressLine1: 'street-2',
        addressLine2: 'unit-2',
        city: 'city-2',
        state: 's2',
        zip: 'zip-2',
        phone: 'phone-2222',
        fax: 'fax-222222',
        county: 'county-2',
        hours: 'hours-2',
        isPrivate: true,
        isInactive: true,
        recordId: null,
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-organization-locations' ingester with environment:
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
    And mongo query "{_id: 'e:oid-1:ext-1:street-2:city-2:s2:zip-2'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1:street-2:city-2:s2:zip-2',
        address: {
          line1: 'street-2',
          line2: 'unit-2',
          city: 'city-2',
          state: 's2',
          zip: 'zip-2',
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.222, 0.222]
        },
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            oid: 'oid-1',
            authority: 'auth-1',
            extension: 'ext-1'
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
        phone: 'phone-2222',
        fax: 'fax-222222',
        county: 'county-2',
        hours: 'hours-2',
        isInactive: true,
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:oid-1:ext-1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        name: 'name-1',
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
            _id: 'c1:rid-1',
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
          },
          {
            _id: 'e:oid-1:ext-1:street-2:city-2:s2:zip-2',
            address: {
              line1: 'street-2',
              line2: 'unit-2',
              city: 'city-2',
              state: 's2',
              zip: 'zip-2'
            },
            geoPoint: {
              type: 'Point',
              coordinates: [0.222, 0.222]
            },
            phone: 'phone-2222'
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
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
    And mongo query "{'organizationRefs.organization._id': 'e:oid-1:ext-1'}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        organizationRefs: [
          {
            organization: {
              locations: [
                {
                  _id: 'c1:rid-1',
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
                },
                {
                  _id: 'e:oid-1:ext-1:street-2:city-2:s2:zip-2',
                  address: {
                    line1: 'street-2',
                    line2: 'unit-2',
                    city: 'city-2',
                    state: 's2',
                    zip: 'zip-2'
                  },
                  geoPoint: {
                    type: 'Point',
                    coordinates: [0.222, 0.222]
                  },
                  phone: 'phone-2222'
                }
              ]
            }
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organization-locations: insert: record-id
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        addressLine1: 'street-2',
        addressLine2: 'unit-2',
        city: 'city-2',
        state: 's2',
        zip: 'zip-2',
        phone: 'phone-2222',
        fax: 'fax-222222',
        county: 'county-2',
        hours: 'hours-2',
        isPrivate: true,
        isInactive: true,
        recordId: 'rid-2',
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-organization-locations' ingester with environment:
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
    And mongo query "{_id: 'c1:rid-2'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-2',
        address: {
          line1: 'street-2',
          line2: 'unit-2',
          city: 'city-2',
          state: 's2',
          zip: 'zip-2',
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.222, 0.222]
        },
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            oid: 'oid-1',
            authority: 'auth-1',
            extension: 'ext-1'
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
        phone: 'phone-2222',
        fax: 'fax-222222',
        county: 'county-2',
        hours: 'hours-2',
        isInactive: true,
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-organization-locations: update
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        addressLine1: 'street-1',
        addressLine2: 'unit-2',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        phone: 'phone-2222',
        isPrivate: true,
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-organization-locations' ingester with environment:
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
    And mongo query "{_id: 'c1:rid-1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        address: {
          line1: 'street-1',
          line2: 'unit-2',
          city: 'city-1',
          state: 's1',
          zip: 'zip-1',
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.111, 0.111]
        },
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            oid: 'oid-1',
            authority: 'auth-1',
            extension: 'ext-1'
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
        phone: 'phone-2222',
        fax: 'fax-111111',
        county: 'county-1',
        hours: 'hours-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """
    And mongo query "{_id: 'e:oid-1:ext-1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        name: 'name-1',
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
            _id: 'c1:rid-1',
            address: {
              line1: 'street-1',
              line2: 'unit-2',
              city: 'city-1',
              state: 's1',
              zip: 'zip-1'
            },
            geoPoint: {
              type: 'Point',
              coordinates: [0.111, 0.111]
            },
            phone: 'phone-2222'
          }
        ],
        identifiers: [
          {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
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
    And mongo query "{'organizationRefs.organization._id': 'e:oid-1:ext-1'}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        organizationRefs: [
          {
            organization: {
              locations: [
                {
                  _id: 'c1:rid-1',
                  address: {
                    line1: 'street-1',
                    line2: 'unit-2',
                    city: 'city-1',
                    state: 's1',
                    zip: 'zip-1'
                  },
                  geoPoint: {
                    type: 'Point',
                    coordinates: [0.111, 0.111]
                  },
                  phone: 'phone-2222'
                }
              ]
            }
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        location: {
          _id: 'c1:rid-1',
          address: {
            line1: 'street-1',
            line2: 'unit-2',
            city: 'city-1',
            state: 's1',
            zip: 'zip-1'
          },
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.111]
          },
          phone: 'phone-2222'
        }
      }
    ]
    """

  Scenario: ingest client-organization-locations: update: non-existent
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'nope',
        extension: 'ext-1',
        addressLine1: 'street-1',
        city: 'city-1',
        state: 's1',
        zip: 'zip-1',
        addressLine2: 'unit-2',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-organization-locations' ingester with environment:
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
    And mongo query "{_id: 'c1:rid-1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        address: {
          line2: 'unit-1',
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """

  Scenario: ingest client-organization-locations: update: record-id
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE}' collection:
    """
    [
      {
        recordId: 'rid-1',
        addressLine1: 'street-2',
        city: 'city-2',
        state: 's2',
        zip: 'zip-2',
        phone: 'phone-2222',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-organization-locations' ingester with environment:
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
    And mongo query "{_id: 'c1:rid-1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        address: {
          line1: 'street-2',
          city: 'city-2',
          state: 's2',
          zip: 'zip-2',
        },
        geoPoint: {
          type: 'Point',
          coordinates: [0.222, 0.222]
        },
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            oid: 'oid-1',
            authority: 'auth-1',
            extension: 'ext-1'
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
        phone: 'phone-2222',
        fax: 'fax-111111',
        county: 'county-1',
        hours: 'hours-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """
