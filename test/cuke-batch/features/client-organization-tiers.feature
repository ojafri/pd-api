@batch
Feature: client organization tiers
  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne',
        networks: [
          {
            _id: 'c1::n1',
            name: 'n1',
            plans: [
              {
                _id: 'c1::n1:p1',
                name: 'n1:p1',
                tiers: [
                  {
                    _id: 'c1::n1:p1:t1',
                    name: 'n1:p1:t1',
                    rank: 1,
                    isInNetwork: true
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organization-tiers: insert
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        }
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
      }
    ]
    """
    When we run the '${BATCH}/client-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organization-tiers: insert: recordId
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        }
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'c1:rid-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
      }
    ]
    """
    When we run the '${BATCH}/client-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        name: 'name-1',
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        tierRefs: [
          {
            _id: 'c1:rid-1:c1::n1:p1:t1',
            tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'c1:rid-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: [
          {
            _id: 'c1:rid-1:c1::n1:p1:t1',
            tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """

Scenario: ingest client-organization-tiers: delete
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.delete
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    When we run the '${BATCH}/client-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        tierRefs: []
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: []
      }
    ]
    """


Scenario: ingest client-organization-tiers:  upsert (e.g. re-run of the file)
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    When we run the '${BATCH}/client-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
        organization: {
          _id: 'e:oid-1:ext-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          name: 'name-1',
          identifiers: [
            {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
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
        tierRefs: [
          {
           _id: 'e:oid-1:ext-1:c1::n1:p1:t1',
           tier: {
              _id: 'c1::n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1::n1:p1',
                network: {
                  _id: 'c1::n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organization-tiers: delete non-existent
      Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
      """
      [
        {
          oid: 'nope',
          extension: 'ext-1',
          tierId: 'c1::n1:p1:t1',
          action: constants.MODES.delete
        }
      ]
      """
      When we run the '${BATCH}/client-organization-tiers' ingester with environment:
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

  Scenario: ingest client-organization-tiers: duplicate insert
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      },
      {
        oid: 'oid-1',
        extension: 'ext-1',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        }
      }
    ]
    """
    When we run the '${BATCH}/client-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1, failed: 1}
    }
    """
