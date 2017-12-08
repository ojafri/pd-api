@api
Feature: restful api to provide access to tiers

  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        networks: [
          {
            _id: 'c1:n1',
            plans: [
              {
                _id: 'c1:n1:p1',
                tiers: [
                  {_id: 'c1:n1:p1:t1', name: 'c1:n1:p1:t1', benefits: 'benefits-1', rank: 1},
                  {
                    _id: 'c1:n1:p1:t2',
                    name: 'c1:n1:p1:t2',
                    benefits: 'benefits-2',
                    rank: 2,
                    isInactive: true,
                    updated: {
                      date: 'date-1'
                    }
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        _id: 'c2',
        networks: [
          {
            _id: 'c2:n1',
            plans: [
              {
                _id: 'c2:n1:p1'
              }
            ]
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'o1',
        tierRefs: [
          {
            _id: 'o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'o1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      },
      {
        _id: 'o2',
        tierRefs: [
          {
            _id: 'o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
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
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'p1',
        tierRefs: [
          {
            _id: 'p1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'p1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      },
      {
        _id: 'p2',
        tierRefs: [
          {
            _id: 'p2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
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
        _id: 'ol1',
        tierRefs: [
          {
            _id: 'ol1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'ol1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      },
      {
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'tier one',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
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
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 's1:p1',
        id: {oid: 'oid1', extension: 'p1'},
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            organization: {_id: 's1:o1'},
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c1:n1:p1:t1',
                tier: {
                  _id: 'c1:n1:p1:t1',
                  name: 'tier one',
                  rank: 1,
                  plan: {
                    _id: 'c1:n1:p1',
                    product: 'c1:n1:pr1',
                    network: {
                      _id: 'c1:n1',
                      client: {
                        _id: 'c1'
                      }
                    }
                  }
                }
              },
              {
                _id: 's1:p1:s1:o1:c2:n1:p1:t1',
                tier: {
                  _id: 'c2:n1:p1:t1',
                  name: 'other tier one',
                  rank: 1,
                  plan: {
                    _id: 'c2:n1:p1',
                    product: 'c2:n1:pr1',
                    network: {
                      _id: 'c2:n1',
                      client: {
                        _id: 'c2'
                      }
                    }
                  }
                }
              }
            ]
          },
          {
            _id: 's1:p1:s1:o2',
            organization: {_id: 's1:o2'}
          }
        ]
      },
      {
        _id: 's1:p2',
        id: {oid: 'oid1', extension: 'p2'},
        organizationRefs: [
          {
            _id: 's1:p2:s1:o2',
            organization: {_id: 's1:o2'}
          }
        ]
      }
    ]
    """

  Scenario: find tiers
    When we HTTP GET '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'c1:n1:p1:t1',
        plan: {
          _id: 'c1:n1:p1',
          network: {
            _id: 'c1:n1',
            client: {
              _id: 'c1'
            }
          }
        }
      },
      {
        _id: 'c1:n1:p1:t2',
        plan: {
          _id: 'c1:n1:p1',
          network: {
            _id: 'c1:n1',
            client: {
              _id: 'c1'
            }
          }
        }
      }
    ]
    """

  Scenario: get tier
    When we HTTP GET '/clients/c1/networks/c1:n2/plans/c1:n1:p2/tiers/c1:n1:p1:t2'
    Then our HTTP response should be like:
    """
    {
      _id: 'c1:n1:p1:t2',
      benefits: 'benefits-2',
      plan: {
        _id: 'c1:n1:p1',
        network: {
          _id: 'c1:n1',
          client: {
            _id: 'c1'
          }
        }
      },
      updated: {
        date: 'date-1'
      }
    }
    """

  Scenario: find inactive tiers
    When we HTTP GET '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers' with query 'isInactive=true'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'c1:n1:p1:t2',
        isInactive: true,
        plan: {
          _id: 'c1:n1:p1',
          network: {
            _id: 'c1:n1',
            client: {
              _id: 'c1'
            }
          }
        }
      }
    ]
    """

  Scenario: create tier
    When we HTTP POST '/clients/c2/networks/c2:n1/plans/c2:n1:p1/tiers' with body:
    """
    {name: 'tier one', rank: 1, isInNetwork: true}
    """
    Then our HTTP response should have status code 201
    And mongo query "{'networks.plans.tiers.name': 'tier one'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c2',
        networks: [
          {
            _id: 'c2:n1',
            plans: [
              {
                _id: 'c2:n1:p1',
                tiers: [
                  {
                    _id: 'c2::1',
                    name: 'tier one',
                    updated: {
                      date: 'assert(actual.constructor.name == "Date")'
                    }
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  """

  Scenario: create invalid tier
    When we HTTP POST '/clients/c2/networks/c2:n1/plans/c2:n1:p1/tiers' with body:
    """
    {nayme: 'tier one'}
    """
    Then our HTTP response should have status code 422

  Scenario: create duplicate tier
    When we HTTP POST '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers' with body:
    """
    {name: 'c1:n1:p1:t1', rank: 1, isInNetwork: true}
    """
    Then our HTTP response should have status code 409

  Scenario: update tier
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers/c1:n1:p1:t1' with body:
    """
    {name: 'updated name', rank: 3, isInNetwork: true, isInactive: true}
    """
    Then our HTTP response should have status code 204
    And mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        networks: [
          {
            _id: 'c1:n1',
            plans: [
              {
                _id: 'c1:n1:p1',
                tiers: [
                  {
                    _id: 'c1:n1:p1:t1',
                    name: 'updated name',
                    rank: 3,
                    isInactive: true,
                    updated: {date: 'assert(actual.constructor.name == "Date")'}
                  },
                  {_id: 'c1:n1:p1:t2'},
                ]
              }
            ]
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier._id': 'c1:n1:p1:t1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'o1',
        tierRefs: [
          {
            _id: 'o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'o1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2
            }
          }
        ]
      },
      {
        _id: 'o2',
        tierRefs: [
          {
            _id: 'o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true
            }
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier._id': 'c1:n1:p1:t1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'p1',
        tierRefs: [
          {
            _id: 'p1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'p1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2
            }
          }
        ]
      },
      {
        _id: 'p2',
        tierRefs: [
          {
            _id: 'p2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true
            }
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier._id': 'c1:n1:p1:t1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'ol1',
        tierRefs: [
          {
            _id: 'ol1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true,
              plan: {
                _id: 'c1:n1:p1',
                product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'ol1:c1:n1:p1:t2',
            tier: {
              _id: 'c1:n1:p1:t2',
              name: 'tier two',
              rank: 2
            }
          }
        ]
      },
      {
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              name: 'updated name',
              rank: 3,
              isInactive: true
            }
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 's1:p1',
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c1:n1:p1:t1',
                tier: {
                  _id: 'c1:n1:p1:t1',
                  name: 'updated name',
                  rank: 3
                }
              },
              {
                _id: 's1:p1:s1:o1:c2:n1:p1:t1',
                tier: {
                  _id: 'c2:n1:p1:t1',
                  name: 'other tier one',
                  rank: 1
                }
              }
            ]
          },
          {
            _id: 's1:p1:s1:o2',
            tierRefs: undefined
          }
        ]
      },
      {
        _id: 's1:p2',
        organizationRefs: [
          {
            _id: 's1:p2:s1:o2',
            tierRefs: undefined
          }
        ]
      }
    ]
    """

  Scenario: update invalid tier
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers/c1:n1:p1:t1' with body:
    """
    {nayme: 'foobar'}
    """
    Then our HTTP response should have status code 422

  Scenario: update duplicate tier name
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers/c1:n1:p1:t1' with body:
    """
    {name: 'c1:n1:p1:t2', rank: 1, isInNetwork: true}
    """
    Then our HTTP response should have status code 409

  Scenario: update duplicate tier rank
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1/tiers/c1:n1:p1:t1' with body:
    """
    {name: 'c1:n1:p1:t1', rank: 2, isInNetwork: true}
    """
    Then our HTTP response should have status code 204
    And mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        networks: [
          {
            _id: 'c1:n1',
            plans: [
              {
                _id: 'c1:n1:p1',
                tiers: [
                  {
                    _id: 'c1:n1:p1:t1',
                    rank: 2
                  },
                  {
                    _id: 'c1:n1:p1:t2',
                    rank: 2
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """
