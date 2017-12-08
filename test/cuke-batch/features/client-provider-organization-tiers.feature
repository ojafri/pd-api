@batch
Feature: client provider organization tiers
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

  Scenario: ingest client-provider-organization-tiers:  insert
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        organizationOid: 'oid-1',
        organizationExtension: 'ext-1',
        providerOid: 'oid-101',
        providerExtension: 'ext-101',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        }
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:e:oid-1:ext-1',
            organization: {
              _id: 'c1:e:oid-1:ext-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:e:oid-101:ext-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:e:oid-1:ext-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
      }
    ]
    """

    When we run the '${BATCH}/client-provider-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:e:oid-1:ext-1',
            organization: {
              _id: 'c1:e:oid-1:ext-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
            tierRefs: [
              {
                _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:e:oid-101:ext-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:e:oid-1:ext-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
        tierRefs: [
          {
           _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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

  Scenario: ingest client-provider-organization-tiers:  insert : recordId
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        organizationOid: 'oid-1',
        organizationExtension: 'ext-1',
        providerAuthority: 'auth-101',
        providerOid: 'oid-101',
        providerExtension: 'ext-101',
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
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'c1:rid-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:rid-1',
            organization: {
              _id: 'c1:rid-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:rid-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:rid-1',
            name: 'name-1',
            id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
      }
    ]
    """

    When we run the '${BATCH}/client-provider-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:rid-1',
            organization: {
              _id: 'c1:rid-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
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
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:rid-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:rid-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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

  Scenario: ingest client-provider-organization-tiers:  delete
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        organizationOid: 'oid-1',
        organizationExtension: 'ext-1',
        providerOid: 'oid-101',
        providerExtension: 'ext-101',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.delete
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
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'c1:rid-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:rid-1',
            organization: {
              _id: 'c1:rid-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
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
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:rid-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:rid-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
    When we run the '${BATCH}/client-provider-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:rid-1',
            organization: {
              _id: 'c1:rid-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
            tierRefs: []
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:rid-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:rid-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:rid-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
        tierRefs: []
      }
    ]
    """

  Scenario: ingest client-provider-organization-tiers:  upsert (e.g. re-run of the file)
    Given the following documents exist in the '${constants.CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE}' collection:
    """
    [
      {
        organizationOid: 'oid-1',
        organizationExtension: 'ext-1',
        providerOid: 'oid-101',
        providerExtension: 'ext-101',
        tierId: 'c1::n1:p1:t1',
        action: constants.MODES.create
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        }
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:e:oid-1:ext-1',
            organization: {
              _id: 'c1:e:oid-1:ext-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
            tierRefs: [
              {
                _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:e:oid-101:ext-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:e:oid-1:ext-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
        tierRefs: [
          {
           _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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

    When we run the '${BATCH}/client-provider-organization-tiers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101',
        name: {
          first: 'f-name-101',
          middle: 'm-name-101',
          last: 'l-name-101',
        },
        id: {
          authority: 'auth-101',
          oid: 'oid-101',
          extension: 'ext-101'
        },
        identifiers: [
          {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          }
        ],
        organizationRefs: [
          {
            _id: 'c1:e:oid-1:ext-1',
            organization: {
              _id: 'c1:e:oid-1:ext-1',
              name: 'name-1',
              id: {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1'
              }
            },
            tierRefs: [
              {
                _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'c1:e:oid-101:ext-101:addressLine1-1:city-1:state-1:zip-1',
        practitioner: {
          _id: 'c1:e:oid-101:ext-101',
          id: {
            authority: 'auth-101',
            oid: 'oid-101',
            extension: 'ext-101'
          },
          name: {
            first: 'f-name-101',
            middle: 'm-name-101',
            last: 'l-name-101',
          },
          identifiers: [
            {
              authority: 'auth-101',
              oid: 'oid-101',
              extension: 'ext-101'
            }
          ]
        },
        location: {
          _id: 'c1:e:oid-1:ext-1:addressLine1-1:city-1:state-1:zip-1',
          organization: {
            _id: 'c1:e:oid-1:ext-1',
            name: 'name-1',
            id: {
              authority: 'auth-1',
              oid: 'oid-1',
              extension: 'ext-1'
            },
            identifiers: [
              {
                authority: 'auth-1',
                oid: 'oid-1',
                extension: 'ext-1',
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
        tierRefs: [
          {
           _id: 'c1:e:oid-1:ext-1:c1::n1:p1:t1',
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
